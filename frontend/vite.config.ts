import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// Dentro do Docker, o backend é alcançado pelo nome do serviço ("backend").
const apiTarget = process.env.VITE_API_PROXY_TARGET ?? 'http://localhost:8000'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: true,
    watch: { usePolling: process.env.VITE_USE_POLLING === 'true', interval: 300 },
    proxy: {
      '/api': { target: apiTarget, changeOrigin: true },
      '/health': { target: apiTarget, changeOrigin: true },
    },
  },
})
