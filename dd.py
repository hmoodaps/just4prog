import secrets
import uuid
from datetime import datetime

from django.db import models
from django.utils import timezone

class TimeStampedModel(models.Model):
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class ProjectRequest(TimeStampedModel):
    TRACKING_PREFIX = "J4P"

    PROJECT_TYPES = (
        ('ecommerce', 'E-Commerce'),
        ('social', 'Social Media'),
        ('enterprise', 'Enterprise Solution'),
        ('custom', 'Custom'),
    )

    STATUS_CHOICES = (
        ('new', 'New'),
        ('review', 'Under Review'),
        ('development', 'In Development'),
        ('testing', 'Testing'),
        ('completed', 'Completed'),
    )

    # Basic Info
    tracking_id = models.CharField(max_length=20, unique=True, editable=False)
    client_name = models.CharField(max_length=255)  # الزامي
    email = models.EmailField()  # الزامي
    phone = models.CharField(max_length=20)  # الزامي

    # Project Details
    project_title = models.CharField(max_length=255)  # الزامي
    project_type = models.CharField(max_length=50, choices=PROJECT_TYPES, blank=True, null=True)
    description = models.TextField()  # الزامي
    target_audience = models.TextField(blank=True, null=True)
    special_requirements = models.TextField(blank=True, null=True)
    PLATFORMS_CHOICES = (
        ('android', 'android'),
        ('ios', 'ios'),
        ('both', 'both'),
    )
    # Technical Specs
    platforms = models.CharField(max_length=8,choices=PLATFORMS_CHOICES, blank=True, null=True)
    has_payment = models.BooleanField(default=False, blank=True, null=True)
    payment_methods = models.JSONField(default=list, blank=True, null=True)
    supported_languages = models.JSONField(default=list, blank=True, null=True)
    data_type = models.CharField(max_length=20, choices=[('static', 'Static'), ('dynamic', 'Dynamic')], default='static', blank=True, null=True)

    # Financial
    total_price = models.DecimalField(max_digits=12, decimal_places=2, default=0, blank=True, null=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='new', blank=True, null=True)

    client_requested_delivery = models.DateTimeField(default=timezone.now)
    estimated_delivery = models.DateTimeField(default=timezone.now)
    actual_delivery = models.DateTimeField(null=True, blank=True)

    def save(self, *args, **kwargs):
        if isinstance(self.client_requested_delivery, datetime.date):
            self.client_requested_delivery = datetime.combine(self.client_requested_delivery, datetime.min.time())

        if isinstance(self.estimated_delivery, datetime.date):
            self.estimated_delivery = datetime.combine(self.estimated_delivery, datetime.min.time())

        if isinstance(self.actual_delivery, datetime.date):
            self.actual_delivery = datetime.combine(self.actual_delivery, datetime.min.time())

        if not self.tracking_id:
            year = timezone.now().strftime('%Y')
            seq = str(uuid.uuid4().int)[:6]
            self.tracking_id = f"{self.TRACKING_PREFIX}-{year}-{seq}"
        super().save(*args, **kwargs)

class ProjectPhase(TimeStampedModel):
    PHASE_TYPES = (
        ('payment', 'Payment'),
        ('design', 'Design Approval'),
        ('development', 'Development'),
        ('modification', 'Modification'),
        ('delivery', 'Delivery'),
    )

    project = models.ForeignKey(ProjectRequest, related_name='phases', on_delete=models.CASCADE)
    phase_type = models.CharField(max_length=20, choices=PHASE_TYPES)
    title = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    due_date = models.DateTimeField()  # تغيير إلى DateTimeField
    completed_date = models.DateTimeField(null=True, blank=True)  # تغيير إلى DateTimeField
    amount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, default=0)
    is_paid = models.BooleanField(default=False)

class ProjectCommunication(TimeStampedModel):
    COMMUNICATION_TYPES = (
        ('email', 'Email'),
        ('meeting', 'Meeting'),
        ('phone', 'Phone'),
        ('system', 'System Notification'),
    )

    project = models.ForeignKey(ProjectRequest, related_name='communications', on_delete=models.CASCADE)
    comm_type = models.CharField(max_length=20, choices=COMMUNICATION_TYPES)
    message = models.TextField()
    sender = models.CharField(max_length=255)
    receiver = models.CharField(max_length=255)
    attachments = models.JSONField(default=list)

class ProjectModification(TimeStampedModel):
    MODIFICATION_TYPES = (
        ('ui', 'UI Change'),
        ('feature', 'New Feature'),
        ('bug', 'Bug Fix'),
        ('content', 'Content Update'),
    )

    project = models.ForeignKey(ProjectRequest, related_name='modifications', on_delete=models.CASCADE)
    mod_type = models.CharField(max_length=20, choices=MODIFICATION_TYPES)
    description = models.TextField(blank=True)
    requested_by = models.CharField(max_length=255)
    status = models.CharField(max_length=20, choices=[
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
        ('completed', 'Completed'),
    ], default='pending')
    cost = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    time_estimate = models.PositiveIntegerField(help_text="Estimated hours needed")

class ProjectDelivery(TimeStampedModel):
    project = models.ForeignKey(ProjectRequest, related_name='deliveries', on_delete=models.CASCADE)
    version = models.CharField(max_length=20)
    delivery_date = models.DateTimeField()  # تغيير إلى DateTimeField
    store_links = models.JSONField(default=dict)
    client_feedback = models.TextField(blank=True)
    is_accepted = models.BooleanField(default=False)

class ProjectAttachment(TimeStampedModel):
    ATTACHMENT_TYPES = (
        ('contract', 'Contract'),
        ('design', 'Design File'),
        ('invoice', 'Invoice'),
        ('report', 'Progress Report'),
    )

    project = models.ForeignKey(ProjectRequest, related_name='attachments', on_delete=models.CASCADE)
    attachment_type = models.CharField(max_length=20, choices=ATTACHMENT_TYPES)
    file = models.FileField(upload_to='attachments/')
    description = models.TextField(blank=True)
    uploaded_by = models.CharField(max_length=255)

class User(models.Model):
    uid = models.CharField(max_length=255, primary_key=True)
    token = models.CharField(max_length=255, unique=True)

    def save(self, *args, **kwargs):
        if not self.token:
            self.token = secrets.token_hex(32)
        super().save(*args, **kwargs)