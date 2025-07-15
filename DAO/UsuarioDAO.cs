using App.StarBemEstetica.Utilitarios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using App.StarBemEstetica.Mapeamento;
using MySql.Data.MySqlClient;
using System.Windows.Forms;
using System.Collections;


namespace App.StarBemEstetica.DAO
{
    public class UsuarioDAO
    {
        private static Conexao conexao = new Conexao();
        public Usuario GetUsuario(string email, string senha)
        {
            MySqlDataReader reader = null;
            try
            {
                string sql = "SELECT * FROM Usuarios WHERE email = @email AND senha = @senha;";
                MySqlCommand comando = new MySqlCommand(sql, Conexao.Conectar());
                comando.Parameters.AddWithValue("@email", email);
                comando.Parameters.AddWithValue("@senha", senha);
                reader = comando.ExecuteReader();

                if (reader.Read())
                {
                    return new Usuario
                    {
                        Id = reader.GetInt32("id_usuario"),
                        Nome = reader.IsDBNull(reader.GetOrdinal("nome")) ? null : reader.GetString("nome"),
                        Email = reader.GetString("email"),
                        TipoUsuarioId = reader.GetInt32("id_tipoUsuario_fk")
                    };
                }
                return null;
            }
            catch(Exception ex)
            {
                throw new Exception("Usuario não encontrado: " + ex.Message);
            }
            finally
            {
                reader?.Close();
                Conexao.FecharConexao();
            }
        }
    }
}
