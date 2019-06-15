Dado('que estou no site google') do
  faz_pesquisa.load
end

Quando('pesquiso por:') do |table_pesq|
  @t_pesquisar = table_pesq.rows_hash
  faz_pesquisa.fazendo_pesquisa(@t_pesquisar)
end

Então('vejo aseguinte frase na tela:') do |mensagem|
  expect(page).to have_content(mensagem)
end
