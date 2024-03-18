import { defineConfig } from 'vitepress'



// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Vinum",
  description: "The website for the Vinum Project.",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
    ],
    sidebar: [
      {
        text: "Introduction",
        items: [
          {text: "Understanding Memory in Vinum", link: "/intro/memory"},
          {text: "Storing Simple Data", link: "/intro/source"},
          {text: "Operating On Data", link: "/intro/operators"},
          {text: "Deriving New Data", link: "/intro/derived"},
          {text: "Mapping Data to Another", link: "/intro/map"},
          {text: "Referencing Data Sources", link: "/intro/ref"},
        ]
      },
      {
        text: "Internal",
        items: [
          {text: "Conditional Value Caching", link: "/internal/conditional-caching"},
        ]
      },
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/vinum-team/Vinum' }
    ]
  },
  markdown: {
    lineNumbers: true
  },
})
