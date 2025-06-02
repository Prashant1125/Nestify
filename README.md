# 🏠 Nestify - Rent Smarter, Live Better

Nestify is a Flutter-based rental room listing application built with Firebase. It allows users to explore available rooms by location and budget, contact owners directly, and express interest in renting. Room owners can manage listings, edit room details, and view users interested in their rooms.

---

## 🚀 Features

- 🔐 **User Authentication**
  - Email/Password and Google Sign-in using Firebase Auth
- 🏘️ **Room Listings**
  - Upload room details with images, rent, location, amenities, etc.
- 📸 **Image Upload**
  - Upload multiple images via imgbb API
- 👀 **Interested Users**
  - Users can show interest once; owners can see the interested users
- 🔍 **Search & Filter**
  - Search by city and filter by rent range (≤2000, ≤5000, >5000)
- 📞 **Call & SMS**
  - Contact room owners directly via tap-to-call and tap-to-message
- ✏️ **Owner Dashboard**
  - Room owners can edit or delete their rooms
- ✅ **Responsive UI**
  - Clean and user-friendly layout with GetX state management

---

## 🎥 Live Demo

[![Watch the demo](https://img.youtube.com/vi/YOUR_VIDEO_ID/0.jpg)]([https://www.youtube.com/watch?v=YOUR_VIDEO_ID](https://youtu.be/ca0Cv-tG-LM))
---

## 🧰 Tech Stack

- **Flutter** & **Dart**
- **GetX** for state management
- **Firebase Authentication**
- **Firebase Realtime Database**
- **imgbb API** for image uploads
- **URL Launcher**, **Carousel Slider**, **Cached Network Image**

---

## 📂 Folder Structure (Simplified)

lib/
├── const/
├── loader/
├── models/
├── screens/
├── controller/
├── components/
├── routes/
├── api/
├── main.dart

yaml
Copy
Edit

---

## 📦 How to Run

1. Clone the repo:
git clone https://github.com/Prashant1125/nestify.git
cd nestify

markdown
Copy
Edit
2. Get dependencies:
flutter pub get

bash
Copy
Edit
3. Run on device/emulator:
flutter run

yaml
Copy
Edit

> ⚠️ Note: You’ll need to configure your own Firebase project and imgbb API key.

---

## 🧑‍💻 Author

**Prashant Kushwaha**  
📍 Gadarwara, MP  
📧 prashantkushwaha0207@gmail.com  
🔗 [LinkedIn](https://linkedin.com/prashant-kushwaha) • [GitHub](https://github.com/Prashant1125)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
