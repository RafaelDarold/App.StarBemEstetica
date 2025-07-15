using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.StarBemEstetica.Mapeamento
{
    public class AtendimentoServico
    {
        public int Id { get; set; }
        public int AtendimentoId { get; set; }
        public int ServicoId { get; set; }
        public double Valor { get; set; }
    }
}
