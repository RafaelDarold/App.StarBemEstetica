-- Objetivo: Listar todos os agendamentos realizados em janeiro de 2023, mostrando informações como:
-- nome do cliente, serviço agendado, data/hora, funcionário responsável e status.

SELECT a.id_agendamento, CONCAT(c.nome, ' ', c.sobrenome) AS cliente, s.nome AS servico, 
	a.dataHoraInicio AS data_hora, f.nome AS funcionario,a.status FROM Agendamentos AS a
INNER JOIN Clientes AS c ON a.id_cliente_fk = c.id_cliente
INNER JOIN Agendamentos_servicos AS ags ON a.id_agendamento = ags.id_agendamento_fk
INNER JOIN Servicos AS s ON ags.id_servico_fk = s.id_servico
INNER JOIN Funcionarios AS f ON a.id_funcionario_fk = f.id_funcionario
WHERE a.dataHoraInicio BETWEEN '2023-01-01' AND '2023-01-31'
ORDER BY a.dataHoraInicio;

-- Mostrar todos os serviços oferecidos pela estética e os aparelhos/produtos associados a cada um, 
-- incluindo serviços que não possuem aparelhos vinculados.

SELECT s.nome AS servico, s.regiaoCorpoAtuacao, pa.nome AS produto_aparelho,
	pa.categoria, pa.status FROM Servicos AS s
LEFT JOIN ProdutosAparelhos_Servicos AS pas ON s.id_servico = pas.id_servico_fk
LEFT JOIN ProdutosAparelhos AS pa ON pas.id_produtoAparelho_fk = pa.id_produtoAparelho
ORDER BY s.nome, pa.categoria;

-- Listar todos os aparelhos/produtos ativos no sistema e os serviços que os utilizam, 
-- incluindo aparelhos que não estão sendo usados em nenhum serviço.

SELECT pa.nome AS produto_aparelho, pa.categoria, pa.regiaoCorpoAtuacao, s.nome AS servico, s.duracaoMedia FROM Servicos AS s
RIGHT JOIN ProdutosAparelhos_Servicos AS pas ON s.id_servico = pas.id_servico_fk
RIGHT JOIN ProdutosAparelhos AS pa ON pas.id_produtoAparelho_fk = pa.id_produtoAparelho
WHERE pa.status = 'Ativo'
ORDER BY pa.categoria, pa.nome;

-- Identificar clientes que tiveram gastos acima da média em atendimentos finalizados, 
-- mostrando total gasto e número de atendimentos.

SELECT c.id_cliente, CONCAT(c.nome, ' ', c.sobrenome) AS cliente, c.email,
    COUNT(a.id_atendimento) AS total_atendimentos, SUM(a.valorTotal) AS total_gasto FROM Clientes AS c
JOIN Agendamentos AS ag ON c.id_cliente = ag.id_cliente_fk
JOIN Atendimentos AS a ON ag.id_agendamento = a.id_agendamento_fk
WHERE a.valorTotal > (SELECT AVG(valorTotal) FROM Atendimentos WHERE status = 'Finalizado') AND a.status = 'Finalizado'
GROUP BY c.id_cliente, cliente, c.email
ORDER BY total_gasto DESC;

-- Listar colaboradores que realizaram mais atendimentos que a média da equipe 
-- (considerando apenas atendimentos finalizados).

SELECT f.id_funcionario, CONCAT(f.nome, ' ', f.sobrenome) AS funcionario, 
	COUNT(a.id_atendimento) AS atendimentos_realizados, SUM(a.valorTotal) AS valor_gerado FROM Funcionarios AS f
INNER JOIN Atendimentos AS a ON f.id_funcionario = a.id_funcionario_fk
WHERE a.status = 'Finalizado'
GROUP BY f.id_funcionario, funcionario
HAVING COUNT(a.id_atendimento) > (SELECT AVG(contagem) FROM (SELECT COUNT(id_atendimento) AS contagem FROM Atendimentos 
WHERE status = 'Finalizado'
GROUP BY id_funcionario_fk) AS media_atendimentos)
ORDER BY atendimentos_realizados DESC;

-- Calcular faturamento total, quantidade de atendimentos e valor médio por serviço durante o periodo de janeiro de 2023.

SELECT s.nome AS servico, COUNT(a.id_atendimento) AS quantidade_realizada,
    SUM(a.valorTotal) AS receita_total, AVG(a.valorTotal) AS ticket_medio FROM Atendimentos a
JOIN Atendimentos_servicos AS ats ON a.id_atendimento = ats.id_atendimento_fk
JOIN Servicos AS s ON ats.id_servico_fk = s.id_servico
WHERE a.dataHoraInicial BETWEEN '2023-01-01' AND '2023-01-31' AND a.status = 'Finalizado'
GROUP BY s.nome
ORDER BY receita_total DESC;

