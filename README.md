# Kids Allowance Tracker (iOS)

A simple iOS app to help a child track pocket money (零花钱) and spending, based on two fixed income rules:

1. Ride a bike to school every school day → **+$5 per day**
2. Every Saturday, if all homework from the previous week got an **A grade** → **+$5 per week**

Expenses are mainly:
- Books
- Toys  
(and optionally other small categories like snacks or “other”)

The app is designed to be **kid-friendly**, **simple**, and **safe**.  
Parent can supervise; the child mainly records income and expenses and watches balance grow.

---

## 1. Target Platform & Tech Stack

- Platform: **iOS**
- UI: **SwiftUI**
- Language: **Swift**
- Minimum iOS version: **iOS 17 or later** (if convenient, can assume iOS 18 / “iOS 26 style” UI only affects design, not SDK)
- Architecture: Simple **MVVM** or “ObservableObject + State” is enough
- Local storage: 
  - First version can use **UserDefaults** or **SwiftData/CoreData** (choose one and document it)
- No backend services required in the first version (offline only)

---

## 2. Design Reference (Figma)

Figma file (generated via Figma Make):

> Kids Allowance Tracker UI  
> https://www.figma.com/make/O0o9kAKqfCa5lSx7omZI4g/Kids-Allowance-Tracker-UI?node-id=0-4

When implementing SwiftUI views, please follow:
- Large rounded cards
- Soft, cheerful colors (blue / teal / yellow as primary accents)
- Large tappable areas suitable for children
- Clear separation of income (green) and expense (red)
- Simple layouts (no overly complex charts)

The Figma structure is a guideline, not pixel-perfect spec.  
Preserve the spirit, not exact pixel values.

---

## 3. App Features (Functional Requirements)

### 3.1 Home / Dashboard

- Displays:
  - Current total balance
  - A short summary of income rules (“Bike to school +$5/day”, “All-A homework +$5/week”)
  - A list of recent transactio
