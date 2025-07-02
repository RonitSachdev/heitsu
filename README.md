# heitsu

**Connect • Match • Meet**

A modern event networking platform built with Rails 8.0.2 that helps people make meaningful connections at events. Swipe through fellow attendees, match with like-minded people, and turn events into lasting relationships.

## ✨ Features

###  Core Functionality
- **Event-Based Networking** - Browse and register for events in your area
- **Smart Matching** - Swipe through attendees at events you're registered for
- **Real-time Chat** - Message your matches before and during events
- **Profile Management** - Showcase your interests and event preferences
- **Match History** - Keep track of all your connections

###  Modern UI/UX
- **Sleek Yellow/Black Theme** - Modern, accessible design system
- **Responsive Design** - Optimized for mobile, tablet, and desktop
- **Smooth Animations** - Engaging micro-interactions and hover effects
- **PWA Ready** - Progressive Web App capabilities for mobile users

###  Pages & Experience
- **Landing Page** - Compelling hero with social proof and testimonials
- **Authentication** - Beautiful login/register pages with consistent branding
- **Dashboard** - Overview of your events, matches, and activity
- **Event Discovery** - Browse and filter events by interests
- **Swipe Interface** - Tinder-like swiping for event attendees
- **Match Management** - View and chat with your connections

## 🚀 Getting Started

### Prerequisites
- Docker & Docker Compose
- Git

### Quick Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd heitsu
   ```

2. **Build and start the application:**
   ```bash
   docker-compose up -d
   ```

3. **Set up the database:**
   ```bash
   docker-compose exec app rails db:create
   docker-compose exec app rails db:migrate
   docker-compose exec app rails db:seed
   ```

4. **Access the application:**
   ```
   🌐 Web: http://localhost:3000
   📱 Mobile-optimized interface available
   ```

## 🛠️ Development

### Common Commands

```bash
# Rails console
docker-compose exec app rails console

# Run migrations
docker-compose exec app rails db:migrate

# Run tests
docker-compose exec app rails test

# Generate sample data
docker-compose exec app rails db:seed

# View logs
docker-compose logs -f app

# Stop containers
docker-compose down
```

### Project Structure

```
heitsu/
├── app/
│   ├── controllers/     # Application controllers
│   ├── models/         # Data models (User, Event, Match, etc.)
│   ├── views/          # ERB templates with modern UI
│   ├── assets/         # Stylesheets and images
│   └── javascript/     # Stimulus controllers
├── config/             # Application configuration
├── db/                 # Database migrations and seeds
└── docker-compose.yml  # Docker services configuration
```

## 🎨 Design System

### Color Palette
- **Primary Yellow**: `#FFC107` - Call-to-action buttons, highlights
- **Primary Dark**: `#FF9800` - Hover states, emphasis
- **Black**: `#000000` - Text, headers, navigation
- **White**: `#ffffff` - Backgrounds, cards
- **Grey Scale**: Various shades for subtle UI elements

### Typography
- **Font**: Inter (Google Fonts)
- **Weights**: 300-700 for various text hierarchy
- **Modern spacing** and line heights for readability

## 🏗️ Tech Stack

### Backend
- **Rails 8.0.2** - Latest Ruby on Rails framework
- **PostgreSQL** - Robust relational database
- **Solid Cache** - High-performance caching
- **Solid Queue** - Background job processing
- **Action Cable** - Real-time WebSocket connections

### Frontend
- **ERB Templates** - Server-rendered HTML
- **Modern CSS** - Custom design system with CSS variables
- **Importmap** - No-build JavaScript management
- **Turbo & Stimulus** - Hotwire for modern interactions
- **Progressive Web App** - Mobile app-like experience

### Infrastructure
- **Docker** - Containerized development and deployment
- **Docker Compose** - Multi-service orchestration

## 📊 Key Models

- **User** - Profile, authentication, preferences
- **Event** - Event details, location, categories
- **EventRegistration** - User event attendance
- **UserSwipe** - Swipe history (like/pass)
- **UserMatch** - Mutual likes between users
- **Message** - Chat functionality between matches

## 🔒 Authentication & Security

- **Secure Authentication** - bcrypt password hashing
- **Session Management** - Rails secure sessions
- **CSRF Protection** - Built-in Rails security
- **Content Security Policy** - XSS protection

## 🌐 Deployment

The application is Docker-ready and can be deployed to any container platform:

- **Heroku** - With Docker support
- **AWS ECS/Fargate** - Container orchestration
- **DigitalOcean App Platform** - Simple container deployment
- **Railway** - Modern deployment platform

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Contact

For questions or support, please open an issue or contact the development team.

---

**Made with ❤️ using Rails 8.0.2 and modern web technologies**

*Connecting people, one event at a time* 🎯
