using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
using System.Drawing;

namespace App.StarBemEstetica.Utilitarios
{
    internal class Conexao
    {
        private static MySqlConnection conexao;
        public static MySqlConnection Conectar()
        {
            try
            {
                string strconexao = "server=localhost;port=3306;uid=root;pwd=root;database=starBemEstetica";
                conexao = new MySqlConnection(strconexao);
                conexao.Open();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro na conexão com o Banco de Dados" + ex.Message);
            }

            return conexao;
        }
        public static void FecharConexao()
        {
            conexao.Close();
        }
    }
}
