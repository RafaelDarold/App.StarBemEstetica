using App.StarBemEstetica.DAO;
using App.StarBemEstetica.Mapeamento;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using App.StarBemEstetica.Views;
using App.StarBemEstetica.Utilitarios;
using MySql.Data.MySqlClient;

namespace App.StarBemEstetica.Views
{
    public partial class AtualizarClienteForm : Form
    {
        private Cliente _cliente;
        internal AtualizarClienteForm(Cliente cliente)
        {
            InitializeComponent();
            _cliente = cliente;
            CarregarDadosCliente();
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
        private void CarregarDadosCliente()
        {
            txtNome.Text = _cliente._Nome;
            txtSobrenome.Text = _cliente._Sobrenome;
            txtCpf.Text = _cliente._Cpf;
            dtpDataNascimentoCliente.Value = _cliente._DataNasc;
            txtEmail.Text = _cliente._Email;
            cbSexo.SelectedItem = _cliente._Sexo;
            txtTelefone.Text = _cliente._Telefone;

            if (_cliente._Endereco != null)
            {
                txtCep.Text = _cliente._Endereco._Cep;
                txtRua.Text = _cliente._Endereco._Rua;
                txtNumero.Text = _cliente._Endereco._Numero;
                txtBairro.Text = _cliente._Endereco._Bairro;
                txtCidade.Text = _cliente._Endereco._Cidade;
                txtEstado.Text = _cliente._Endereco._Estado;
            }
        }
        private void btSalvar_Click(object sender, EventArgs e)
        {
            string sexo = cbSexo.SelectedItem.ToString();

            if (sexo == "Masculino")
            {
                sexo = "M";
            }
            if (sexo == "Feminino")
            {
                sexo = "F";
            }
            if (sexo == "Outros")
            {
                sexo = "O";
            }

            _cliente._Nome = txtNome.Text;
            _cliente._Sobrenome = txtSobrenome.Text;
            _cliente._Cpf = txtCpf.Text;
            _cliente._DataNasc = dtpDataNascimentoCliente.Value;
            _cliente._Email = txtEmail.Text;
            _cliente._Sexo = sexo;
            _cliente._Telefone = txtTelefone.Text;

            if (_cliente._Endereco != null)
            {
                _cliente._Endereco._Numero = txtNumero.Text;
            }

            ClienteDAO dao = new ClienteDAO();
            dao.AtualizarCliente(_cliente);

            MessageBox.Show("Cliente atualizado com sucesso!");
            this.DialogResult = DialogResult.OK;
            this.Close();
        }
        private void btCancelar_Click(object sender, EventArgs e)
        {
            this.Hide();
            ListarClienteForm form = new ListarClienteForm();
            form.ShowDialog();
            this.Close();
        }
        private void btBuscarCep_Click(object sender, EventArgs e)
        {
            BuscarEnderecoPorCEP();
        }
    }
}
