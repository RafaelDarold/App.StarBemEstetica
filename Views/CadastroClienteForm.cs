using App.StarBemEstetica.DAO;
using App.StarBemEstetica.Mapeamento;
using App.StarBemEstetica.Utilitarios;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using App.StarBemEstetica.Utilitarios;

namespace App.StarBemEstetica.Views
{
    public partial class CadastroClienteForm : Form
    {
        public CadastroClienteForm()
        {
            InitializeComponent();
        }
        public void BuscarEnderecoPorCEP()
        {
            string cep = txtCep.Text.Replace("-", "").Trim();

            if (cep.Length != 8)
            {
                MessageBox.Show("CEP inválido. Deve conter 8 dígitos.", "Aviso",
                              MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                {
                    string sql = @"SELECT id_endereco, cep, rua, numero, bairro, cidade, estado, pais
                         FROM Endereco 
                         WHERE cep = @cep";

                    MySqlCommand cmd = new MySqlCommand(sql, Conexao.Conectar());
                    cmd.Parameters.AddWithValue("@cep", cep);

                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
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
                                _Pais = reader["pais"].ToString(),
                            };


                            txtRua.Text = endereco._Rua;
                            txtBairro.Text = endereco._Bairro;
                            txtCidade.Text = endereco._Cidade;
                            txtEstado.Text = endereco._Estado;
                            txtPais.Text = endereco._Pais;

                            this.Tag = endereco;

                            txtNumero.Focus();
                        }
                        else
                        {
                            MessageBox.Show("Endereço não encontrado para o CEP informado.", "Aviso",
                                          MessageBoxButtons.OK, MessageBoxIcon.Information);
                            this.Tag = null;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao buscar endereço: {ex.Message}", "Erro",
                              MessageBoxButtons.OK, MessageBoxIcon.Error);
                this.Tag = null;
            }
        }
        private void btSalvar_Click(object sender, EventArgs e)
        {
            try
            {
                string sexo = cbSexo.SelectedItem.ToString();
                
                    if(sexo == "Masculino")
                {
                    sexo = "M";
                }if(sexo == "Feminino")
                {
                    sexo = "F";
                }if(sexo == "Outros")
                {
                    sexo = "O";
                }

                if (!(this.Tag is Endereco endereco) || endereco._IdEndereco <= 0)
                {
                    MessageBox.Show("Endereço inválido. Por favor, busque um CEP válido antes de salvar.",
                                  "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                endereco._Numero = txtNumero.Text.Trim();

                var cliente = new Cliente
                {
                    _Nome = txtNome.Text.Trim(),
                    _Sobrenome = txtSobrenome.Text.Trim(),
                    _Cpf = txtCpf.Text.Replace(",", "").Replace("-", "").Trim(),
                    _DataNasc = dtpDataNascimentoCliente.Value,
                    _Email = txtEmail.Text.Trim(),
                    _Sexo = sexo,
                    _Telefone = txtTelefone.Text.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "").Trim(),
                    _Endereco = endereco
                };

                var clienteDAO = new ClienteDAO();
                bool sucesso = clienteDAO.CadastrarCliente(cliente);

                if (sucesso)
                {
                    MessageBox.Show("Cliente cadastrado com sucesso!", "Sucesso",
                                  MessageBoxButtons.OK, MessageBoxIcon.Information);
                    txtNome.Clear();
                    txtSobrenome.Clear();
                    txtCpf.Clear();
                    txtEmail.Clear();
                    txtTelefone.Clear();
                    cbSexo.Items.Clear();
                    txtCep.Clear();
                    txtRua.Clear();
                    txtNumero.Clear();
                    txtBairro.Clear();
                    txtCidade.Clear();
                    txtEstado.Clear();
                    txtPais.Clear();
                    txtNome.Focus();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao salvar cliente: {ex.Message}", "Erro",
                              MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private void btCancelar_Click(object sender, EventArgs e)
        {
            txtNome.Clear();
            txtSobrenome.Clear();
            txtCpf.Clear();
            txtEmail.Clear();
            txtTelefone.Clear();
            cbSexo.Items.Clear();
            txtCep.Clear();
            txtRua.Clear();
            txtNumero.Clear();
            txtBairro.Clear();
            txtCidade.Clear();
            txtEstado.Clear();
            txtPais.Clear();
            txtNome.Focus();
        }
        private void btBuscarCep_Click(object sender, EventArgs e)
        {
            BuscarEnderecoPorCEP();
        }
    }
}
