# Netlify Deployment Stappen

## Stap 1: Netlify Account Aanmaken (5 minuten)

1. Ga naar https://app.netlify.com/signup
2. Klik op "Sign up with GitHub" (aanbevolen)
3. Autoriseer Netlify toegang tot je GitHub account

## Stap 2: Nieuwe Site Maken (5 minuten)

1. Na inloggen, klik op "Add new site" → "Import an existing project"
2. Kies "GitHub" als Git provider
3. Zoek naar "TEAMAPP.AI" repository
4. Selecteer de repository

## Stap 3: Build Settings Configureren

Vul de volgende instellingen in:

- **Base directory**: `jo17_tactical_manager`
- **Build command**: `flutter build web --release --web-renderer canvaskit --tree-shake-icons`
- **Publish directory**: `jo17_tactical_manager/build/web`

## Stap 4: Environment Variables Toevoegen

Ga naar Site settings → Environment variables en voeg toe:

```
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
```

⚠️ **Belangrijk**: Vervang de waarden met je echte Supabase credentials

## Stap 5: Deploy Site

1. Klik op "Deploy site"
2. Wacht tot de build compleet is (5-10 minuten)
3. Je site is live op: `https://[random-name].netlify.app`

## Stap 6: Custom Domain (Optioneel)

1. Ga naar Site settings → Domain management
2. Klik "Add custom domain"
3. Voeg toe: `jo17.voab.nl` (of je gewenste domein)
4. Volg de DNS instructies

## Stap 7: Verificatie

Test de volgende functies:

- [ ] Login pagina laadt correct
- [ ] Demo mode werkt
- [ ] Navigatie werkt
- [ ] Responsive design op mobile
- [ ] Performance (Lighthouse score > 90)

## Troubleshooting

### Build Fails
- Check de build logs in Netlify
- Zorg dat alle dependencies in pubspec.yaml staan
- Controleer of environment variables zijn ingesteld

### Blank Page
- Check browser console voor errors
- Verifieer dat de build directory correct is
- Controleer CORS settings in Supabase

### Slow Loading
- Gebruik de performance tab in Chrome DevTools
- Overweeg tree shaking en code splitting
- Check bundle size in Netlify dashboard

## Next Steps

1. **Monitoring Setup**
   - Sentry voor error tracking
   - Google Analytics voor usage

2. **Performance Optimalisatie**
   - Enable Netlify Asset Optimization
   - Configure caching headers
   - Implement lazy loading

3. **Security**
   - Enable Netlify Identity (optioneel)
   - Configure security headers
   - Setup SSL certificate (automatisch)

## Belangrijke URLs

- GitHub Repository: https://github.com/Rul1an/TEAMAPP.AI
- Netlify Dashboard: https://app.netlify.com
- Live Site: [wordt gegenereerd na deployment]

---

Voor support: Check de Netlify docs of vraag hulp in de Flutter community.
