using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using App.StarBemEstetica.DAO;

namespace App.StarBemEstetica.Mapeamento
{
    public class Usuario
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public string Email { get; set; }
        public string Senha { get; set; }
        public int TipoUsuarioId { get; set; }
 public static bool Login(string email, string senha)
        {
            var usuario = new UsuarioDAO().GetUsuario(email, senha);

            if (usuario != null)
                return true;

            return false;
        }
    }
}
