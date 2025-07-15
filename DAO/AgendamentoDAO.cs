using App.StarBemEstetica.Mapeamento;
using App.StarBemEstetica.Utilitarios;
using Google.Protobuf.WellKnownTypes;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;


namespace App.StarBemEstetica.DAO
{
    internal class AgendamentoDAO
    {
        public void CadastrarAgendamento(Agendamento agendamento)
        {
            try
            {
                string sql = "INSERT INTO Agendamentos(dataHoraInicio, dataHoraFinal, observacao, status, valor, id_cliente_fk, id_funcionario_fk) " +
                    "VALUES(@dataInicio, @dataFinal, @observacao, @status, @valor, @clienteId, @funcionarioId); SELECT LAST_INSERT_ID();";
                MySqlCommand comando = new MySqlCommand(sql, Conexao.Conectar());
                comando.Parameters.AddWithValue("@dataInicio", agendamento._DataHoraInicio);
                comando.Parameters.AddWithValue("@dataFinal", agendamento._DataHoraFinal);
                comando.Parameters.AddWithValue("@observacao", agendamento._Observacao);
                comando.Parameters.AddWithValue("@status", agendamento._Status);
                comando.Parameters.AddWithValue("@valor", agendamento._Valor);
                comando.Parameters.AddWithValue("@clienteId", agendamento._ClienteId);
                comando.Parameters.AddWithValue("@funcionarioId", agendamento._FuncionarioId);
                comando.ExecuteNonQuery();

                agendamento._Id = Convert.ToInt32(comando.ExecuteScalar());

                // Cadastro de serviços ao agendamento
                foreach (var servico in agendamento.Servicos)
                {
                    comando.CommandText = "INSERT INTO Agendamentos_servicos (valor, id_agendamento_fk, id_servico_fk) " +
                                    "VALUES (@valor, @agendamentoId, @servicoId)";
                    comando.Parameters.Clear();
                    comando.Parameters.AddWithValue("@valor", servico.Valor);
                    comando.Parameters.AddWithValue("@agendamentoId", agendamento._Id);
                    comando.Parameters.AddWithValue("@servicoId", servico.ServicoId);
                    comando.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            finally
            {
                Conexao.FecharConexao();
            }
        }

        public void AtualizarAgendamento(Agendamento agendamento)
        {
            try
            {
                string sql = "UPDATE Agendamento SET dataHoraInicio = @dataInicio, dataHoraFinal = @dataFinal, observacao = @observacao, status = @status," +
                " valor = @valor, id_cliente_fk = @clienteId, id_funcionario_fk = @funcionarioId WHERE id_agendamento = @id";
                MySqlCommand comando = new MySqlCommand(sql, Conexao.Conectar());
                comando.Parameters.AddWithValue("@dataInicio", agendamento._DataHoraInicio);
                comando.Parameters.AddWithValue("@dataFinal", agendamento._DataHoraFinal);
                comando.Parameters.AddWithValue("@observacao", agendamento._Observacao);
                comando.Parameters.AddWithValue("@status", agendamento._Status);
                comando.Parameters.AddWithValue("@valor", agendamento._Valor);
                comando.Parameters.AddWithValue("@clienteId", agendamento._ClienteId);
                comando.Parameters.AddWithValue("@funcionarioId", agendamento._FuncionarioId);
                comando.Parameters.AddWithValue("@id", agendamento._Id); 
                
                comando.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            finally
            {
                Conexao.FecharConexao();
            }                                                       
        }
    }
}