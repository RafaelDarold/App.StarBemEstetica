using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.StarBemEstetica.Mapeamento
{
    public class Atendimento
    {
        public int _Id {  get; set; }
        public DateTime _DataHoraInicial { get; set; }
        public DateTime _DataHoraFinal { get; set; }
        public string _Observacao { get; set; }
        public string _Status { get; set; }
        public TimeSpan _Duracao { get; set; }
        public double _ValorFinal { get; set; }
        public string _FormaPagamento { get; set; }
        public int AgendamentoId { get; set; }
        public int FuncionarioId { get; set; }
        public List<AtendimentoServico> Servicos { get; set; } = new List<AtendimentoServico>();
    }
}
