---
name: Urban Feline Tracker
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1c1b1b'
  on-surface-variant: '#564338'
  inverse-surface: '#313030'
  inverse-on-surface: '#f3f0ef'
  outline: '#897266'
  outline-variant: '#ddc1b3'
  surface-tint: '#9b4500'
  primary: '#9b4500'
  on-primary: '#ffffff'
  primary-container: '#ff8c42'
  on-primary-container: '#6a2d00'
  inverse-primary: '#ffb68d'
  secondary: '#2b4cda'
  on-secondary: '#ffffff'
  secondary-container: '#4967f4'
  on-secondary-container: '#fffbff'
  tertiary: '#765b06'
  on-tertiary: '#ffffff'
  tertiary-container: '#c9a751'
  on-tertiary-container: '#503c00'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbc9'
  primary-fixed-dim: '#ffb68d'
  on-primary-fixed: '#331200'
  on-primary-fixed-variant: '#763300'
  secondary-fixed: '#dee1ff'
  secondary-fixed-dim: '#bac3ff'
  on-secondary-fixed: '#001159'
  on-secondary-fixed-variant: '#0031c4'
  tertiary-fixed: '#ffdf96'
  tertiary-fixed-dim: '#e7c269'
  on-tertiary-fixed: '#251a00'
  on-tertiary-fixed-variant: '#594400'
  background: '#fcf9f8'
  on-background: '#1c1b1b'
  surface-variant: '#e5e2e1'
typography:
  display-lg:
    fontFamily: Lexend
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Lexend
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Lexend
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
  headline-md:
    fontFamily: Lexend
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Lexend
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Lexend
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-bold:
    fontFamily: Lexend
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Lexend
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  container-padding: 20px
  gutter: 16px
---

## Brand & Style

The design system is built for a vibrant, community-driven experience centered around street cat discovery and care. The brand personality is energetic, empathetic, and "chronically online" in its aesthetic choices—targeting a Gen Z audience that values both high-functionality and "aesthetic" visual appeal. 

The style is a fusion of **Modern-Rounded** and **Soft-Tactile**. It leverages high-saturation colors to create a sense of urgency and excitement, balanced by soft, pill-like shapes that evoke the friendly nature of the subject matter. The interface should feel like a premium toy: interactive, bouncy, and deeply satisfying to touch.

## Colors

This design system utilizes a high-contrast, four-color primary palette to categorize information and drive engagement:

- **Bright Orange (#FF8C42):** Used for primary actions, alerts, and high-priority cat sightings.
- **Electric Blue (#4361EE):** Used for navigation, map markers, and interactive links.
- **Soft Yellow (#FFD97D):** Used for "warmth" elements, highlights, and status badges for friendly cats.
- **Mint Green (#B4F8C8):** Used for success states, health-related information, and secondary backgrounds.

The background remains a crisp white to allow the vibrant colors to pop without causing visual fatigue. Dark mode should use a deep navy (#0F172A) rather than pure black to maintain color harmony.

## Typography

Lexend is the exclusive typeface for this design system. Its geometric clarity and varied weights provide the necessary readability for outdoor use (mapping) while maintaining the playful, modern character required for the brand.

- **Headlines:** Use Bold (700) or ExtraBold (800) for all headings. Tighten letter spacing slightly on larger display text to create a more "packed" and impactful look.
- **Body:** Use Regular (400) for long-form content. The generous x-height of Lexend ensures legibility even on small mobile screens.
- **Interactions:** Use Medium (500) or SemiBold (600) for buttons and navigation labels to ensure they stand out against vibrant backgrounds.

## Layout & Spacing

The layout philosophy follows a **Fluid Grid** model with generous safe areas. 

- **Mobile First:** The core experience is mobile. Use a 4-column grid with 20px side margins and 16px gutters.
- **Vertical Rhythm:** Use a 4px baseline. Most spacing should utilize `lg` (24px) or `xl` (32px) to prevent the UI from feeling cramped.
- **Floating Elements:** Map-based interfaces should utilize "floating" panels rather than edge-to-edge sheets, leaving at least 12px of visible background around the panel to emphasize the layered, "aesthetic" depth.

## Elevation & Depth

This design system uses a combination of **Glassmorphism** and **Soft Shadows** to create a tactile, layered environment.

- **Primary Elevation:** Floating cards and buttons use a "Thick Soft Shadow." This is achieved with a high blur radius (24px+) and low opacity (10-15%) using a tinted version of the primary color or a neutral deep blue.
- **Glassmorphism:** Navigation bars and secondary overlays should use a backdrop blur (20px) with a semi-transparent white fill (80% opacity). Add a subtle 1px white inner border to simulate a glass edge.
- **Active State:** When pressed, elements should "sink" by reducing shadow spread and scaling down slightly (98%), giving a physical, "squishy" feedback loop.

## Shapes

The shape language is defined by **Extreme Roundedness**. Almost all containers, including cards and input fields, should default to a minimum of 32px corner radius.

- **Buttons & Chips:** Always use fully rounded "Pill" shapes.
- **Image Containers:** Use a 32px radius. For "featured" cat photos, consider using slightly asymmetrical "organic blob" shapes to add playfulness.
- **Icons:** Icons should be thick-stroked (2px minimum) with rounded caps and joins to match the typography and container language.

## Components

- **Buttons:** Primary buttons use a solid Bright Orange background with White Bold text. They must have a "Thick Soft Shadow" that matches the button color (#FF8C42 at 20% opacity).
- **Cards:** White or Mint Green backgrounds with 32px corners. Content inside cards should have at least 24px of internal padding.
- **Chips/Badges:** Use high-contrast pairings (e.g., Electric Blue background with White text) for status indicators like "Spotted Recently" or "Needs Food."
- **Input Fields:** Thick 2px borders in Electric Blue when focused. Use a 32px corner radius and a subtle Soft Yellow tint for the background to make them feel inviting.
- **Map Markers:** Custom cat-head silhouettes or "paw" icons inside a circular pill shape, using the primary palette to indicate cat temperament or status.
- **Progress Bars:** Use thick, rounded tracks (12px height) with vibrant gradients moving from Soft Yellow to Bright Orange.