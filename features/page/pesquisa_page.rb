class FazPesquisa < SitePrism::Page
  set_url '/'
  element :pesquisa_desk, 'input[name=q]'
  element :pesquisa_mobile, '.gLFyf'
  element :bt_desk, 'input[name=btnK]'
  element :bt_mobile_a, 'button[aria-label="Voltar"]>div>span'
  element :bt_mobile, 'button[aria-label="Pesquisa Google"]>div>span'

  def fazendo_pesquisa(t_a)
    pesquisa_desk.set t_a['Pesquisa']
    bt_desk.click
  end
end
