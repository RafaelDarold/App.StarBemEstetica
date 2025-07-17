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

namespace App.StarBemEstetica.Views
{
    public partial class ListarClienteForm : Form
    {
        public ListarClienteForm()
        {
            InitializeComponent();
            CarregarClientes();
        }
        private void CarregarClientes()
        {
            try
            {
                var clienteDAO = new ClienteDAO();
                var clientes = clienteDAO.ListarTodos();

                DataTable table = new DataTable();
                table.Columns.Add("IdCliente", typeof(int));
                table.Columns.Add("NomeCompleto", typeof(string));
                table.Columns.Add("TelefoneFormatado", typeof(string));
                table.Columns.Add("Email", typeof(string));

                foreach (var cliente in clientes)
                {
                    table.Rows.Add(
                        cliente._IdCliente,
                        $"{cliente._Nome} {cliente._Sobrenome}",
                        cliente._Telefone,
                        cliente._Email
                    );
                }

                dgvListaClientes.DataSource = table;
                lblTotalClientes.Text = $"Total de clientes: {clientes.Count}";
                AjustarColunas();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao carregar clientes: {ex.Message}", "Erro",
                              MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private void AjustarColunas()
        {
            foreach (DataGridViewColumn column in dgvListaClientes.Columns)
            {
                if (column.AutoSizeMode != DataGridViewAutoSizeColumnMode.Fill &&
                    column.AutoSizeMode != DataGridViewAutoSizeColumnMode.None)
                {
                    column.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
                }
            }
            dgvListaClientes.Update();
            dgvListaClientes.Refresh();
        }

            private string FormatTelefone(string telefone)
        {
            if (string.IsNullOrEmpty(telefone))
                return telefone;

            if (telefone.Length == 11)
                return $"({telefone.Substring(0, 2)}) {telefone.Substring(2, 5)}-{telefone.Substring(7, 4)}";

            if (telefone.Length == 10)
                return $"({telefone.Substring(0, 2)}) {telefone.Substring(2, 4)}-{telefone.Substring(6, 4)}";

            return telefone;
        }
    
    private void btNovoCliente_Click(object sender, EventArgs e)
        {
            this.Hide();
            CadastroClienteForm form = new CadastroClienteForm();
            form.ShowDialog();
            this.Close();
        }

        private void btDeletar_Click(object sender, EventArgs e)
        {
            if (dgvListaClientes.SelectedRows.Count > 0)
            {
                int idCliente = Convert.ToInt32(dgvListaClientes.SelectedRows[0].Cells["IdCliente"].Value);

                DialogResult confirmacao = MessageBox.Show(
                    "Tem certeza que deseja excluir este cliente?",
                    "Confirmação",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question);

                if (confirmacao == DialogResult.Yes)
                {
                    ClienteDAO dao = new ClienteDAO();
                    dao.DeletarCliente(idCliente);

                    CarregarClientes();

                    MessageBox.Show("Cliente excluído com sucesso!");
                }
            }
            else
            {
                MessageBox.Show("Selecione um cliente para excluir.");
            }
        }

        private void btAtualizar_Click(object sender, EventArgs e)
        {
            if (dgvListaClientes.SelectedRows.Count > 0)
            {
                if (dgvListaClientes.SelectedRows.Count > 0)
                {
                    try
                    {
                        int idCliente = Convert.ToInt32(dgvListaClientes.SelectedRows[0].Cells["IdCliente"].Value);

                        ClienteDAO dao = new ClienteDAO();
                        Cliente cliente = dao.BuscarPorId(idCliente);

                        if (cliente != null)
                        {
                            AtualizarClienteForm formEdicao = new AtualizarClienteForm(cliente);
                            if (formEdicao.ShowDialog() == DialogResult.OK)
                            {
                                CarregarClientes();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Erro ao editar cliente: {ex.Message}", "Erro",
                                      MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
                else
                {
                    MessageBox.Show("Selecione um cliente para editar.", "Aviso",
                                  MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }
    }
}
