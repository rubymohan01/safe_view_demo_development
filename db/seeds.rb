# Clear old data
User.destroy_all
Organization.destroy_all
Channel.destroy_all
Video.destroy_all
OrganizationInvitation.destroy_all
Policy.destroy_all

youth_org = Organization.create!(name: "Youth Network", status: :active)
united_kindness_org = Organization.create!(name: "United kindness", status: :active)

youth_org.create_policy!(min_age: 13, parental_consent_required: true)
united_kindness_org.create_policy!(min_age: 18, parental_consent_required: false)

User.create!(
  email: "super@admin.com",
  name: "Super Admin",
  password: "password",
  role: :super_admin,
  date_of_birth: 30.years.ago
)

admin_youth = User.create!(
  email: "admin@youth.com",
  name: 'Youth Admin',
  password: "password",
  role: :admin,
  organization_id: youth_org.id,
  date_of_birth: 30.years.ago
)

teen_user = User.create!(
  email: "teen@youth.com",
  name: 'Teen User',
  password: "password",
  role: :user,
  organization_id: youth_org.id,
  date_of_birth: 14.years.ago
)

user_3 = User.create!(
  email: "user1@united.com",
  name: 'User1',
  password: "password",
  role: :user,
  organization_id: united_kindness_org.id,
  date_of_birth: 35.years.ago
)

kids_channel = Channel.create!(
  name: "Kids Channel",
  user: admin_youth,
  organization_id: youth_org.id
)

learning_channel = Channel.create!(
  name: "learning",
  user: user_3,
  organization_id: united_kindness_org.id
)

Video.create!(
  title: "Learn to Share | Animated Kids Video",
  description: "A fun guide for kids on sharing and kindness.",
  channel: kids_channel,
  youtube_url: "https://www.youtube.com/watch?v=RmS9SscwRX4&list=RDRmS9SscwRX4",
  visibility: :everyone,
  min_age: 6
)

Video.create!(
  title: "Bluey | Best Moments 2023",
  description: "The best scenes from Bluey - a hit Australian kids show.",
  channel: kids_channel,
  youtube_url: "https://www.youtube.com/watch?v=AF2XwmwFJqE",
  visibility: :members_only,
  min_age: 8
)

# Teen Video
Video.create!(
  title: "Study With Me – 1 Hour Deep Focus",
  description: "Pomodoro session with lo-fi music, ideal for teens studying.",
  channel: kids_channel,
  youtube_url: "https://www.youtube.com/watch?v=lFcSrYw-ARY",
  visibility: :members_only,
  min_age: 13
)

Video.create!(
  title: "TED Talk: The Power of Vulnerability – Brené Brown",
  description: "Insightful talk on psychology and connection.",
  channel: learning_channel,
  youtube_url: "https://www.youtube.com/watch?v=iCvmsMzlF7o",
  visibility: :everyone,
  min_age: 18
)

Video.create!(
  title: "CrashCourse Philosophy: What is Justice?",
  description: "An introduction to philosophy's approach to justice.",
  channel: learning_channel,
  youtube_url: "https://www.youtube.com/watch?v=kBdfcR-8hEY",
  visibility: :everyone,
  min_age: 18
)
