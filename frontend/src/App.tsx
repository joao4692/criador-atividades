import { useEffect, useState } from 'react'

type Estado = 'verificando' | 'ok' | 'erro'

export default function App() {
  const [api, setApi] = useState<Estado>('verificando')

  useEffect(() => {
    fetch('/health')
      .then((r) => (r.ok ? r.json() : Promise.reject(new Error(String(r.status)))))
      .then(() => setApi('ok'))
      .catch(() => setApi('erro'))
  }, [])

  return (
    <main style={{ fontFamily: 'system-ui, sans-serif', padding: 32 }}>
      <h1>Criador de Atividades com IA</h1>
      <p>
        Backend:{' '}
        <strong>
          {api === 'verificando' ? 'verificando…' : api === 'ok' ? 'conectado' : 'sem resposta'}
        </strong>
      </p>
    </main>
  )
}
