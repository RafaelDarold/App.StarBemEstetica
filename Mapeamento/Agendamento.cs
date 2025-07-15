using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.StarBemEstetica.Mapeamento
{
    public class Agendamento
    {
        public int _Id {  get; set; }
        public DateTime _DataHoraInicio { get; set; }
        public DateTime _DataHoraFinal {  get; set; }
        public string _Observacao { get; set; }
        public string _Status {  get; set; }
        public double _Valor {  get; set; }
        public int _ClienteId { get; set; }
        public int _FuncionarioId { get; set; }
        public List<AgendamentoServico> Servicos { get; set; } = new List<AgendamentoServico>();
    }
}
