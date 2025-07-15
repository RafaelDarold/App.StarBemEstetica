using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MySql.Data.MySqlClient;
using App.StarBemEstetica.Utilitarios;
using App.StarBemEstetica.Mapeamento;
using App.StarBemEstetica.Views;

namespace App.StarBemEstetica
{
    public partial class Form1 : Form
    {
        private static Conexao conexao = new Conexao();
        public Form1()
        {
            InitializeComponent();
        }

        private void btEntrar_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text;
            string senha = txtSenha.Text;
            if (Usuario.Login(email, senha))
            {
                this.Hide();
                AgendamentoForm form = new AgendamentoForm();
                form.ShowDialog();
                this.Close();
            }
            else
            {
                MessageBox.Show("Usuario não encontrado!");
                txtEmail.Clear();
                txtSenha.Clear();
                txtEmail.Focus();
            }
        }
    }
}
