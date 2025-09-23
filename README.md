
# 📄 Product Listing App

## Overview

A simple **mobile and tablet app** that lists products with **infinite scrolling**.

* **Mobile (phone)** → Products and Favourites are shown via **Bottom Navigation**.
* **Tablet / large screens** → **Side-by-side layout**, where the Products and Favourites pages appear together.

This project was created as a **reference implementation** of **MVVM + BLoC + Clean Architecture** in Flutter, showcasing responsive layouts, scalable state management, and separation of concerns.

---
## ✦ Features

* **Product listing with infinite scroll** → Seamlessly loads more items as you scroll.
* **Favourites** → Mark/unmark products and view them instantly.
* **Responsive UI** →

    * Phones → Bottom navigation for switching between tabs.
    * Tablets / large screens → Side-by-side Products and Favourites.
* **Optimistic updates** → Favourite toggles reflect instantly, with rollback on failure.
* **Consistent UI** → Minimal design with **black & white icons only** for clarity.

---
## ✦ Architecture

This app demonstrates **MVVM + BLoC + Clean Architecture** principles:

* **MVVM (Model–View–ViewModel)**

    * *View* → Flutter widgets
    * *ViewModel* → BLoC (manages state, exposes UI models)
    * *Model* → Domain entities

* **BLoC**

    * Provides predictable, reactive state management.
    * Encapsulates business logic and exposes immutable UI states.

* **Clean Architecture**

    * **Domain layer** → Entities & UseCases (pure business rules).
    * **Data layer** → Repositories, DB, API integration.
    * **Presentation layer** → UI + BLoCs + UI Models.
    * Clear separation makes the app **extensible and testable**.

## ✦ Why This Approach?

* **Extensibility** → Adding new features (filters, sorting, new pages) requires minimal changes.
* **Testability** → Each layer can be tested independently (repositories, use cases, BLoCs, mappers).
* **Maintainability** → Separation of concerns keeps codebase organized.
* **Reusability** → Mappers, entities, and UI models are modular and reusable across features.

## ✦ Tech Stack

* **Flutter** for UI
* **BLoC** for state management
* **get\_it** for dependency injection
* **Room-like local DB layer** (via repository pattern)
* **Clean Architecture** for structure and scalability

---

## ✦ Screens

**Phone (Bottom Navigation)**

```
+--------------------------+
|        Products          |
|          (or)            |
|        Favourites        |
+--------------------------+
|   Product | Favourite    |
|        Bottom Nav        |
+--------------------------+
```

**Tablet (Side by Side)**

```
+-----------+--------------+
| Products  |  Favourites  |
+-----------+--------------+
```


## ✦ Purpose

This app is built primarily as a **reference project** to demonstrate:

* How to use **BLoC** effectively in MVVM + Clean Architecture.
* How to design apps that are **responsive** across phone and tablet layouts.
* How to keep code **extensible, testable, and maintainable** in Flutter projects.
