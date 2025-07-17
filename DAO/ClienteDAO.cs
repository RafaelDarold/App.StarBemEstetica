using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using App.StarBemEstetica.Mapeamento;
using MySql.Data.MySqlClient;
using App.StarBemEstetica.Utilitarios;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;
using System.Windows.Forms;

namespace App.StarBemEstetica.DAO
{
    internal class ClienteDAO
    {
        public bool CadastrarCliente(Cliente cliente)
        {
            try
            {
                string sql = @"INSERT INTO Clientes (nome, sobrenome, cpf, dataNasc, email, sexo, telefone, id_endereco_fk) " +
                    "VALUES(@nome, @sobrenome, @cpf, @dataNasc, @email, @sexo, @telefone, @id_endereco)";
                MySqlCommand comando = new MySqlCommand(sql, Conexao.Conectar());
                comando.Parameters.AddWithValue("@nome", cliente._Nome);
                comando.Parameters.AddWithValue("@sobrenome", cliente._Sobrenome);
                comando.Parameters.AddWithValue("@cpf", cliente._Cpf);
                comando.Parameters.AddWithValue("@dataNasc", cliente._DataNasc);
                comando.Parameters.AddWithValue("@email", cliente._Email);
                comando.Parameters.AddWithValue("@sexo", cliente._Sexo);
                comando.Parameters.AddWithValue("@telefone", cliente._Telefone);
                comando.Parameters.AddWithValue("@id_endereco", cliente._Endereco._IdEndereco);
                int rowsAffected = comando.ExecuteNonQuery();
                return rowsAffected > 0;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao inserir cliente: " + ex.Message);
                return false;
            }
            finally
            {
                Conexao.FecharConexao();
            }
        }

        public List<Endereco> ListarEnderecosCadastrados()
        {
            List<Endereco> enderecos = new List<Endereco>();

            try
            {
                string sql = @"SELECT id_endereco, cep, rua, numero, bairro, cidade, estado, pais
                          FROM Endereco";

                MySqlCommand comando = new MySqlCommand(sql, Conexao.Conectar());
                MySqlDataReader reader = comando.ExecuteReader();

                while (reader.Read())
                {
                    Endereco endereco = new Endereco
                    {
                        _IdEndereco = Convert.ToInt32(reader["id_endereco"]),
                        _Cep = reader["cep"].ToString(),
                        _Rua = reader["rua"].ToString(),
                        _Numero = reader["numero"].ToString(),
                        _Bairro = reader["bairro"].ToString(),
                        _Cidade = reader["cidade"].ToString(),
                        _Estado = reader["estado"].ToString(),
                        _Pais = reader["pais"].ToString()
                    };

                    enderecos.Add(endereco);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao listar endereços: " + ex.Message);
            }
            finally
            {
                Conexao.FecharConexao();
            }

            return enderecos;
        }
        public List<Cliente> ListarTodos()
        {
            List<Cliente> lista = new List<Cliente>();

            try
            {

                string sql = @"SELECT id_cliente, nome, sobrenome, telefone, email
                     FROM Clientes
                     ORDER BY nome";

                MySqlCommand cmd = new MySqlCommand(sql, Conexao.Conectar());

                using (MySqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Cliente cliente = new Cliente
                        {
                            _IdCliente = Convert.ToInt32(reader["id_cliente"]),
                            _Nome = reader["nome"].ToString(),
                            _Sobrenome = reader["sobrenome"].ToString(),
                            _Telefone = reader["telefone"].ToString(),
                            _Email = reader["email"].ToString()
                        };

                        lista.Add(cliente);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao listar clientes: " + ex.Message);
            }
            finally
            {
                    Conexao.FecharConexao();
            }

            return lista;
        }
        public void AtualizarCliente(Cliente cliente)
        {
            try
            {
                string sql = @"UPDATE Clientes 
                     SET nome = @nome, sobrenome = @sobrenome, cpf = @cpf, 
                         dataNasc = @dataNasc, email = @email, sexo = @sexo, telefone = @telefone,
                         id_endereco_fk = @id_endereco
                     WHERE id_cliente = @id_cliente";

                MySqlCommand comando = new MySqlCommand(sql, Conexao.Conectar());
                comando.Parameters.AddWithValue("@nome", cliente._Nome);
                comando.Parameters.AddWithValue("@sobrenome", cliente._Sobrenome);
                comando.Parameters.AddWithValue("@cpf", cliente._Cpf);
                comando.Parameters.AddWithValue("@dataNasc", cliente._DataNasc);
                comando.Parameters.AddWithValue("@email", cliente._Email);
                comando.Parameters.AddWithValue("@sexo", cliente._Sexo);
                comando.Parameters.AddWithValue("@telefone", cliente._Telefone);
                comando.Parameters.AddWithValue("@id_endereco", cliente._Endereco._IdEndereco);
                comando.Parameters.AddWithValue("@id_cliente", cliente._IdCliente);
                comando.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao atualizar cliente: " + ex.Message);
            }
            finally
            {
                    Conexao.FecharConexao();
            }
        }
        public void DeletarCliente(int idCliente)
        {
            try
            {
                string sql = "DELETE FROM Clientes WHERE id_cliente = @id_cliente";
                MySqlCommand comando = new MySqlCommand(sql, Conexao.Conectar());
                comando.Parameters.AddWithValue("@id_cliente", idCliente);
                comando.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao deletar cliente: " + ex.Message);
            }
            finally
            {
                    Conexao.FecharConexao();
            }
        }
        public Cliente BuscarPorId(int idCliente)
        {
            try
            {
                string sql = @"SELECT c.id_cliente, c.nome, c.sobrenome, c.cpf, c.dataNasc, 
                             c.email, c.sexo, c.telefone, c.id_endereco_fk,
                             e.cep, e.rua, e.numero, e.bairro, e.cidade, e.estado, e.pais
                      FROM Clientes c
                      INNER JOIN Endereco e ON c.id_endereco_fk = e.id_endereco
                      WHERE c.id_cliente = @id_cliente";

                MySqlCommand comando = new MySqlCommand(sql, Conexao.Conectar());
                comando.Parameters.AddWithValue("@id_cliente", idCliente);

                using (MySqlDataReader reader = comando.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        Cliente cliente = new Cliente();
                        cliente._IdCliente = Convert.ToInt32(reader["id_cliente"]);
                        cliente._Nome = reader["nome"].ToString();
                        cliente._Sobrenome = reader["sobrenome"].ToString();
                        cliente._Cpf = reader["cpf"].ToString();
                        cliente._DataNasc = Convert.ToDateTime(reader["dataNasc"]);
                        cliente._Email = reader["email"].ToString();
                        cliente._Sexo = reader["sexo"].ToString();
                        cliente._Telefone = reader["telefone"].ToString();

                        cliente._Endereco = new Endereco();
                        cliente._Endereco._IdEndereco = Convert.ToInt32(reader["id_endereco_fk"]);
                        cliente._Endereco._Cep = reader["cep"].ToString();
                        cliente._Endereco._Rua = reader["rua"].ToString();
                        cliente._Endereco._Numero = reader["numero"].ToString();
                        cliente._Endereco._Bairro = reader["bairro"].ToString();
                        cliente._Endereco._Cidade = reader["cidade"].ToString();
                        cliente._Endereco._Estado = reader["estado"].ToString();
                        cliente._Endereco._Pais = reader["pais"].ToString();

                        return cliente;
                    }
                }
                return null;
            }
            finally
            {
                    Conexao.FecharConexao();
            }
        }
    }
}

