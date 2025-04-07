

// /* Otherwise just put the config content (json): */
// // التهيئة الأساسية لـ Firebase
// const firebaseConfig = {
//   apiKey: "AIzaSyAZKEpZ3Dkob9EekzDAOh_g8FO0OxAdA-M",
//   authDomain: "just4prog-website.firebaseapp.com",
//   projectId: "just4prog-website",
//   storageBucket: "just4prog-website.firebasestorage.app",
//   messagingSenderId: "333979709686",
//   appId: "1:333979709686:web:035ea9f31683fa10c43cd7",
//   measurementId: "G-XGKYFS5PFB"
// };

// // Initialize Firebase
// firebase.initializeApp(firebaseConfig);

// // الربط مع الزر
// document.addEventListener('DOMContentLoaded', () => {
//   const form = document.getElementById('project-form');
  
//   form.addEventListener('submit', async (e) => {
//     e.preventDefault();
    
//     // جمع البيانات من الحقول
//     const formData = {
//       name: document.querySelector('[name="name"]').value,
//       email: document.querySelector('[name="email"]').value,
//       phone: document.querySelector('[name="phone"]').value,
//       project_title: document.querySelector('[name="project_title"]').value,
//       description: document.querySelector('[name="project_description"]').value,
//       project_type: document.querySelector('[name="project_type"]').value,
//       platform: document.querySelector('[name="platform"]').value,
//       password: document.querySelector('#password').value
//     };

//     try {
//       // الخطوة 1: إرسال بيانات المشروع إلى API
//       const projectResponse = await fetch('https://just4prog-api.vercel.app/projects/', {
//         method: 'POST',
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json'
//         },
//         body: JSON.stringify({
//           client_name: formData.name,
//           email: formData.email,
//           phone: formData.phone,
//           project_title: formData.project_title,
//           description: formData.description,
//           project_type: formData.project_type,
//           platforms: formData.platform,
//           status: "new"
//         })
//       });

//       const projectData = await projectResponse.json();
//       const trackingId = projectData.project_data.tracking_id;
//       console.log("Project Response:", projectData); 
//       // الخطوة 2: إنشاء مستخدم في Firebase Authentication
//       const userCredential = await firebase.auth().createUserWithEmailAndPassword(
//         formData.email,
//         formData.password
//       );
//       const uid = userCredential.user.uid;

//       // الخطوة 3: إنشاء مستخدم في API الخاص بك
//       const userApiResponse = await fetch('https://just4prog-api.vercel.app/api/users/', {
//         method: 'POST',
//         headers: {
//           'Content-Type': 'application/json'
//         },
//         body: JSON.stringify({ uid })
//       });
//       const userApiData = await userApiResponse.json();
//       console.log("User API Response:", userApiData);
//       const token = userApiData.token;

//       // الخطوة 4: إضافة البيانات إلى Firestore
//       await firebase.firestore().collection('users').doc(uid).set({
//         token: token,
//         email: formData.email,
//         dateJoined: new Date(),
//         name: formData.name,
//         phone: formData.phone,
//         projects: [trackingId]
//       });

//       // رسالة نجاح
//       alert('Project created successfully! You can now login to your dashboard.');

//       form.reset();

//     } catch (error) {
//       console.error('Error:', error);
//       alert('Error: ' + error.message);
//     }
//   });
// });

// // رسالة نجاح
// alert('Project created successfully! You can now login to your dashboard.');

// // إضافة التأثير لإظهار الرسالة
// const successMessage = document.getElementById('success-message');
// successMessage.style.display = 'block';
// setTimeout(() => {
//   successMessage.classList.add('show'); // سيظهر التأثير بعد إضافة الكلاس
// }, 100);

// // إخفاء الرسالة بعد فترة (اختياري)
// setTimeout(() => {
//   successMessage.classList.remove('show');
//   setTimeout(() => {
//     successMessage.style.display = 'none'; // إخفاء الرسالة بعد التأثير
//   }, 1000); // بعد التأثير
// }, 5000); // تبقى الرسالة لمدة 5 ثوانٍ

