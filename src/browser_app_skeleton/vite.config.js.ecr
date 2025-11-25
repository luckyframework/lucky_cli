import { defineConfig } from 'vite'
import { resolve } from 'path'
import compression from 'vite-plugin-compression'
import devManifest from 'vite-plugin-dev-manifest'

// https://vitejs.dev/config/
export default defineConfig({
  // Root directory is project root (where vite.config.js is)
  root: '.',
  
  // Public directory for static assets
  publicDir: 'public/assets',
  
  // Build configuration
  build: {
    // Output directory
    outDir: 'public',
    // Don't empty the output directory (Lucky serves from public/)
    emptyOutDir: false,
    // Generate manifest for Lucky asset helpers
    manifest: true,
    // Define entry points
    rollupOptions: {
      input: {
        // These entry names map to asset paths in Lucky:
        // "app" -> asset("js/app.js")
        // "styles" -> asset("css/app.scss")
        app: resolve(__dirname, 'src/js/app.js'),
        styles: resolve(__dirname, 'src/css/app.scss')
      }
    },
    // Asset output configuration
    assetsDir: 'assets',
    // Source maps for production
    sourcemap: process.env.NODE_ENV === 'production' ? false : 'inline'
  },
  
  // CSS configuration
  css: {
    devSourcemap: true
  },
  
  // Server configuration for development
  server: {
    // This allows Vite to be accessed from Lucky's dev server
    origin: 'http://localhost:3001',
    port: 3001,
    strictPort: true,
    // Enable HMR
    hmr: {
      host: 'localhost'
    }
  },
  
  // Preview server configuration (for testing production builds)
  preview: {
    port: 3001
  },
  
  // Plugins
  plugins: [
    // Generate dev manifest for Lucky's compile-time asset validation
    devManifest({
      manifestName: 'manifest.dev',
      clearOnClose: false
    }),
    // Gzip compression for production builds
    process.env.NODE_ENV === 'production' && compression({
      algorithm: 'gzip',
      ext: '.gz',
      threshold: 1024,
    }),
    // Add Brotli compression if desired
    // process.env.NODE_ENV === 'production' && compression({
    //   algorithm: 'brotliCompress',
    //   ext: '.br',
    //   threshold: 1024,
    // }),
  ].filter(Boolean),
  
  // Resolve configuration
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  }
})