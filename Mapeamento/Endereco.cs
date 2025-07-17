using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace App.StarBemEstetica.Mapeamento
{
    internal class Endereco
    {
        public int _IdEndereco {  get; set; }
        public string _Cep {  get; set; }
        public string _Rua {  get; set; }
        public string _Numero { get; set; }
        public string _Bairro { get; set; }
        public string _Cidade { get; set; }
        public string _Estado { get; set; }
        public string _Pais { get; set; }
        public override string ToString()
        {
            return $"{_Rua}, {_Numero} - {_Bairro}, {_Cidade}/{_Estado}";
        }
    }
}
