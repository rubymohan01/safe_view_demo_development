
# SafeView — Secure Video Platform for All Ages

**SafeView** is a custom video-sharing platform built with Ruby on Rails that enforces **organization-based access control**, **age-based participation policies**, and **parental consent workflows**.

---

## Features Implemented

### Organization-Based Access Control
- Users can only view **channels and videos** belonging to their organization.
- **Admins** can invite users to their organization via a secure **invitation link**.
- **Super Admin** has full access to all organizations, users, and analytics.

### Age-Based Participation Rules
- Age is collected during signup via `date_of_birth`.
- Videos are filtered based on age groups:
  - **Child (0–12)**
  - **Teen (13–17)**
  - **Adult (18+)**
- Users under 18 require **parental consent** to access adult content.

### Parental Consent System
- Minor users without parental consent are restricted from viewing 18+ videos.
- Consent is managed via `ParentalConsent` model connecting minors to guardians.

### Invitation Flow
- Admin searches for an existing user by email.
- Generates a **secure invitation link**.
- User visits the link, signs up (or logs in), and is added to the organization.

### Admin & User Dashboards
- Super Admin sees:
  - Total videos, channels, organizations
  - Video stats by age group
- Org Admin sees:
  - Their organization's channels and videos
  - Members and invitation options
- Regular users:
  - See their org’s videos (if permitted)
  - Respond to invitations
  - View videos based on age & consent

---

## Tech Stack

- **Ruby:** 3.3.7
- **Rails:** 7.1.5.1
- **Database:** PostgreSQL
- **Authentication:** Devise
- **Frontend:** Bootstrap 5, Select2
- **JS Bundling:** esbuild

---

## Getting Started

### 1. Clone & Install

```bash
git clone https://github.com/your-username/safeview.git
cd safeview
bundle install
yarn install
```

### 2. Set Up Database

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 3. Start the App

```bash
rails server
```

Visit: [http://localhost:3000](http://localhost:3000)

---

### 3. Start the App
creadential:
1. email: super@admin.com, password: password, role: super admin
2. email: admin@youth.com, password: password, role: admin
3. email: teen@youth.com, password: password,  role: user

##  User Roles

| Role         | Capabilities |
|--------------|--------------|
| **Super Admin** | Full access to all organizations, users, channels, and videos |
| **Admin**        | Manages one organization: channels, videos, invites |
| **User**         | Accesses org content based on age and consent |

---

## Key Models

- `User` — with `role`, `date_of_birth`, `organization_id`
- `Organization`, `Membership` — links users to orgs
- `Channel` — belongs to organization, holds videos
- `Video` — has `min_age`, `visibility`, `channel_id`
- `ParentalConsent` — connects minors with guardians
- `OrganizationInvitation` — tracks invite token, email, org

---

## Dashboard Snapshots

### Super Admin Dashboard
- See total organizations, videos, channels
- View video stats by age group

### Admin Dashboard
- Manage organization’s content
- Search + invite users

### User Dashboard
- View invitation alerts
- View age-appropriate content

---

## Parental Consent Workflow

- Users under 18 require parental approval.
- Without consent:
  - Child/Teen content only.
- With consent:
  - Full access to appropriate videos.

## Parental Consent Workflow
- Safe View Demo:- https://www.loom.com/share/4085e25bce814170b71811f4306b3528?sid=135be1bd-632f-457b-a0cf-4a983c3bde6e