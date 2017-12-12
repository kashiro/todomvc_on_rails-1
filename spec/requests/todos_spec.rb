require 'rails_helper'

RSpec.describe TodosController do

  describe 'GET root' do
    it 'return 200' do
      get root_url
      expect(response).to have_http_status 200
    end
  end

  describe 'POST todos' do
    it 'return 200' do
      post todos_url, params: { todo: attributes_for(:todo) }
      expect(response).to have_http_status 200
    end
    it 'should make new todo' do
      expect do
        post todos_url, params: { todo: attributes_for(:todo) }
      end.to change(Todo, :count).by 1
    end
  end

  describe 'PUT todos' do
    let(:todo) {FactoryBot.create(:todo)}
    it 'return 200' do
      put todo_url(todo), params: { todo: { title: 'updated title', completed: false } }
      expect(response).to have_http_status 200
    end

    it 'should update todo' do
      expect do
        put todo_url(todo), params: { todo: { title: 'updated title', completed: false } }
      end.to change { Todo.find(todo.id).title }.from(todo.title).to('updated title')
    end
  end

  describe 'DELETE todos' do
    let(:todo) {FactoryBot.create(:todo)}

    it 'return 200' do
      delete todo_url(todo)
      expect(response).to have_http_status 200
    end

    it 'should delete todo' do
      expect do
        delete todo_url(todo)
      end.to change(Todo, :count).by(0)
    end
  end

  describe 'GET active_todos' do
    before do
      @todos = FactoryBot.create_list(:todo, 2)
      @todos_completed = FactoryBot.create_list(:todo, 3, :completed)
    end

    it 'return 200' do
      get active_todos_url
      expect(response).to have_http_status 200
    end

    it 'should contain active todo' do
      get active_todos_url
      @todos.each do |todo|
        expect(response.body).to include(todo.title)
      end
    end

    it 'should not contain completed todo' do
      get active_todos_url
      @todos_completed.each do |todo|
        expect(response.body).not_to include(todo.title)
      end
    end
  end

  describe 'GET completed_todos' do
    before do
      @todos = FactoryBot.create_list(:todo, 2)
      @todos_completed = FactoryBot.create_list(:todo, 3, :completed)
    end

    it 'return 200' do
      get completed_todos_url
      expect(response).to have_http_status 200
    end

    it 'should not contain active todo' do
      get completed_todos_url
      @todos.each do |todo|
        expect(response.body).not_to include(todo.title)
      end
    end

    it 'should contain completed todo' do
      get completed_todos_url
      @todos_completed.each do |todo|
        expect(response.body).to include(todo.title)
      end
    end
  end

  describe 'POST toggle_todo' do

    before do
      @todo = FactoryBot.create(:todo)
    end

    it 'return 200' do
      post toggle_todo_url(@todo)
      expect(response).to have_http_status 200
    end

    # There might be issue about change matcher for ActiveRecord
    # That's why we do not use it here.
    it 'toggle todo (completed:false -> completed:true)' do
      expect(@todo.completed).to be_falsy
      post toggle_todo_url(@todo)
      expect(Todo.find(@todo.id).completed).to be_truthy
    end

    it 'toggle todo (completed:true -> completed:false)' do
      @todo = FactoryBot.create(:todo, :completed)
      expect(@todo.completed).to be_truthy
      post toggle_todo_url(@todo)
      expect(Todo.find(@todo.id).completed).to be_falsy
    end
  end

  describe 'POST toggle_all_todos' do
    before do
      @todos = FactoryBot.create_list(:todo, 3)
    end

    it 'return 200' do
      post toggle_all_todos_url
      expect(response).to have_http_status 200
    end

    it 'toggle todo (completed:false -> completed:true)' do
      expect do
        post toggle_all_todos_url
      end.to change(Todo, :active).by []
    end

    it 'toggle todo (completed:true -> completed:false)' do
      @todos = FactoryBot.create_list(:todo, 3, :completed)
      expect do
        post toggle_all_todos_url
      end.to change(Todo, :completed).by []
    end
  end

  describe 'DELETE destroy_completed_todos' do
    before do
      @todos = FactoryBot.create_list(:todo, 3, :completed)
    end

    it 'return 200' do
      delete destroy_completed_todos_url
      expect(response).to have_http_status 200
    end

    it 'should delete completed todos' do
      expect do
        delete destroy_completed_todos_url
      end.to change(Todo, :completed).by []
    end
  end

end
