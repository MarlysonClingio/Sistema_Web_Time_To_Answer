namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop:_unsafe)}
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      show_spinner("Populando BD...") {%x(rails db:seed)}
      show_spinner("Criando o Administrador padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Criando o Usuário padrão...") { %x(rails dev:add_default_user) }
      show_spinner("Adicionando administradores extras...") { %x(rails dev:add_extra_admins) }
      show_spinner("Cadastrando assuntos padrões...") { %x(rails dev:add_subjects) }
      show_spinner("Cadastrando algumas questões e respostas...") { %x(rails dev:add_answers_and_questions) }
    else
      puts "Você não está em ambiente em desenvolvimento!"
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona outros administradores extras"
  task add_extra_admins: :environment do
    20.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona assuntos padrões"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona questões e respostas"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_questions_params(subject)
        answer_array = params[:question][:answers_attributes]
        add_answer(answer_array)
        elect_true_answer(answer_array)
        Question.create!( params[:question])
      end
    end
  end
  
  private # Metodos Privados Abaixo

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success(msg_end)
  end

  def create_answer_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct }
  end

  def create_questions_params(subject = Subject.all.sample)
    { question: 
      { description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
        subject: subject, answers_attributes: []
      }
    }
  end

  def add_answer(answer_array = [])
    rand(2..5).times do |j|
      answer_array.push(create_answer_params)
    end
  end

  def elect_true_answer(answer_array = [])
    selected_index = rand(answer_array.size)
    answer_array[selected_index] = create_answer_params(true)
  end
end