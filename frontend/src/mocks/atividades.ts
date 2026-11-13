export type TipoAtividade =
  | 'multipla_escolha'
  | 'verdadeiro_falso'
  | 'aberta'
  | 'mista'

export type AtividadeResumo = {
  id: number
  assunto: string
  tipo: TipoAtividade
  data_criacao: string
}

export const atividades: AtividadeResumo[] = [
  {
    id: 1,
    assunto: 'Frações e números decimais',
    tipo: 'multipla_escolha',
    data_criacao: '2026-11-10T12:00:00Z',
  },
  {
    id: 2,
    assunto: 'Sistema solar',
    tipo: 'mista',
    data_criacao: '2026-11-08T12:00:00Z',
  },
  {
    id: 3,
    assunto: 'Ciclo da água',
    tipo: 'aberta',
    data_criacao: '2026-11-05T12:00:00Z',
  },
]
