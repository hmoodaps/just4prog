import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just4prog/app/components/constants/assets_manager.dart';
import 'package:just4prog/app/components/constants/dio_and_mapper_constants.dart';
import 'package:just4prog/app/components/constants/font_manager.dart';
import 'package:just4prog/app/components/constants/icons_manager.dart';
import 'package:just4prog/app/components/constants/variables_manager.dart';
import 'package:just4prog/data/dio_handller/dio_handller.dart';
import 'package:just4prog/domain/local_models/models.dart';
import 'package:just4prog/presentation/just_4_prog_bloc/app_states.dart';
import 'package:just4prog/presentation/just_4_prog_bloc/just_4_prog_bloc.dart';
import 'package:just4prog/presentation/routes/edit_project_from_client/edit_project_details_model.dart';
import 'package:just4prog/presentation/routes/main_route/main_route.dart';

import '../../../app/components/constants/general_strings.dart';
import '../../../app/components/constants/notification_handler.dart';
import '../../../data/models/project_req_model/project_request_model.dart';

class EditProjectDetailsFromClient extends StatefulWidget {
  final ProjectRequestModel project;

  const EditProjectDetailsFromClient({super.key, required this.project});

  @override
  State<EditProjectDetailsFromClient> createState() =>
      _EditProjectDetailsFromClientState();
}

class _EditProjectDetailsFromClientState
    extends State<EditProjectDetailsFromClient> {
  late final EditProjectModel _model;

  @override
  void initState() {
    super.initState();
    _model = EditProjectModel(project: widget.project, context: context);
    _model.start();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Just4ProgBloc, AppState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(IconsManager.trueIcon)),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: IconsManager.arrowBack,
          ),
          title: Text(
            "Edit project ${widget.project.project_title}",
            style: TextStyleManager.titleStyle(
              context,
            )?.copyWith(color: Colors.white),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                spacing: 20,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: trackingIdController,
                    labelText: "Tracking ID",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: emailController,
                    labelText: "Email",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: clientNameController,
                    labelText: "Client Name",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: phoneController,
                    labelText: "Phone",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: projectTitleController,
                    labelText: "Project Title",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: projectTypeController,
                    labelText: "Project Type",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: descriptionController,
                    labelText: "Description",
                    maxLines: 5,
                    maxLength: 4000,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: targetAudienceController,
                    labelText: "Target Audience",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: specialRequirementsController,
                    labelText: "Special Requirements",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: platformsController,
                    labelText: "Platforms",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: hasPaymentController,
                    labelText: "Has Payment",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: supportedLanguagesController,
                    labelText: "Supported Languages",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: dataTypeController,
                    labelText: "Data Type",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: routesController,
                    labelText: "Routes",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: clientRequestedDeliveryController,
                    labelText: "Client Requested Delivery",
                    readOnly: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                          );
                          if (selectedTime != null) {
                            DateTime combinedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            clientRequestedDeliveryController.text =
                                DateFormat('yyyy-MM-dd HH:mm')
                                    .format(combinedDateTime);
                          }
                        }
                      },
                    ),
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: haveReadyApiController,
                    labelText: "Have Ready API",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: apiLinkController,
                    labelText: "API Link",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: apiDocsController,
                    labelText: "API Documentation",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: weHaveToMakeApiController,
                    labelText: "Need API Development",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: companyWebsiteController,
                    labelText: "Company Website",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: companyContactDetailsController,
                    labelText: "Company Contact Details",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: companyAboutUsController,
                    labelText: "Company About Us",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: termsAcceptedController,
                    labelText: "Terms Accepted",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: privacyPolicyAcceptedController,
                    labelText: "Privacy Policy Accepted",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: budgetRangeController,
                    labelText: "Budget Range",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: paymentTermsController,
                    labelText: "Payment Terms",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: companyNameController,
                    labelText: "Company Name",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: companyRegistrationNumberController,
                    labelText: "Company Registration Number",
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: createdController,
                    labelText: "Created Date",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: modifiedController,
                    labelText: "Modified Date",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: totalPriceController,
                    labelText: "Total Price",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: statusController,
                    labelText: "Status",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: estimatedDeliveryController,
                    labelText: "Estimated Delivery",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: actualDeliveryController,
                    labelText: "Actual Delivery",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: clientTrainingProvidedController,
                    labelText: "Client Training Provided",
                    readOnly: true,
                    enabled: false,
                  ),
                  defaultTextFormField(
                    context: context,
                    controller: trainingDurationController,
                    labelText: "Training Duration",
                    readOnly: true,
                    enabled: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
