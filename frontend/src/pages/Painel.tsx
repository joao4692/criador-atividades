import { atividades as atividadesExemplo, type AtividadeResumo } from '../mocks/atividades'

type PainelProps = {
  atividades?: AtividadeResumo[]
}

const tipoAtividadeLabel: Record<AtividadeResumo['tipo'], string> = {
  multipla_escolha: 'Múltipla escolha',
  verdadeiro_falso: 'Verdadeiro ou falso',
  aberta: 'Aberta',
  mista: 'Mista',
}

const formatarData = (data: string) =>
  new Intl.DateTimeFormat('pt-BR').format(new Date(data))

export default function Painel({ atividades = atividadesExemplo }: PainelProps) {
  return (
    <main
      style={{
        maxWidth: 960,
        margin: '0 auto',
        padding: 32,
        fontFamily: 'system-ui, sans-serif',
        color: '#1f2937',
      }}
    >
      <header
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          gap: 16,
          marginBottom: 32,
        }}
      >
        <div>
          <h1 style={{ margin: 0 }}>Painel do professor</h1>
          <p style={{ marginBottom: 0, color: '#6b7280' }}>Suas atividades</p>
        </div>
        <nav aria-label="Ações do professor" style={{ display: 'flex', gap: 12 }}>
          <a
            href="/atividades/nova"
            style={{
              padding: '10px 16px',
              borderRadius: 6,
              backgroundColor: '#2563eb',
              color: '#fff',
              textDecoration: 'none',
            }}
          >
            Criar atividade
          </a>
          <a
            href="/login"
            style={{
              padding: '10px 16px',
              borderRadius: 6,
              border: '1px solid #d1d5db',
              color: '#374151',
              textDecoration: 'none',
            }}
          >
            Sair
          </a>
        </nav>
      </header>

      <section aria-labelledby="atividades-titulo">
        <h2 id="atividades-titulo">Atividades recentes</h2>
        {atividades.length === 0 ? (
          <p>Você ainda não criou nenhuma atividade.</p>
        ) : (
          <ul
            style={{
              display: 'grid',
              gap: 12,
              listStyle: 'none',
              margin: 0,
              padding: 0,
            }}
          >
            {atividades.map((atividade) => (
              <li key={atividade.id}>
                <a
                  href={`/atividades/${atividade.id}`}
                  aria-label={`Abrir atividade: ${atividade.assunto}`}
                  style={{
                    display: 'grid',
                    gridTemplateColumns: '2fr 1fr 1fr',
                    gap: 16,
                    alignItems: 'center',
                    padding: 16,
                    border: '1px solid #e5e7eb',
                    borderRadius: 8,
                    color: 'inherit',
                    textDecoration: 'none',
                  }}
                >
                  <strong>{atividade.assunto}</strong>
                  <span>{tipoAtividadeLabel[atividade.tipo]}</span>
                  <time dateTime={atividade.data_criacao}>
                    {formatarData(atividade.data_criacao)}
                  </time>
                </a>
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  )
}
