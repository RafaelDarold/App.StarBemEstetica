using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.StarBemEstetica.Mapeamento
{
    internal class Cliente
    {
        public int _IdCliente {  get; set; }
        public string _Nome { get; set; }
        public string _Sobrenome { get; set; }
        public string _Cpf {  get; set; }
        public DateTime _DataNasc {  get; set; }
        public string _Email { get; set; }
        public string _Sexo { get; set; }
        public string _Telefone { get; set; }
        public Endereco _Endereco { get; set; }

        public Cliente(int idCliente, string nome, string sobrenome, string cpf, DateTime dataNasc, string email, string sexo, string telefone, Endereco endereco)
        {
            _IdCliente = idCliente;
            _Nome = nome;
            _Sobrenome = sobrenome;
            _Cpf = cpf;
            _DataNasc = dataNasc;
            _Email = email;
            _Sexo = sexo;
            _Telefone = telefone;
            _Endereco = endereco;
        }
        public Cliente(int idCliente)
        {
            _IdCliente = idCliente;
        }
        public Cliente() { }
    }
}
