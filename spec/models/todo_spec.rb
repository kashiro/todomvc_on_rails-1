require "rails_helper"

RSpec.describe Todo do

  it 'has properties' do
    todo = create(:todo)
    expect(todo).to respond_to(:title)
    expect(todo).to respond_to(:completed)
  end

  it 'should return uncompleted items' do
    create_list(:todo, 2)
    Todo.active.each do |todo|
      expect(todo.completed).to be_falsy
    end
    expect(Todo.active.length).to be(2)
  end

  it 'should return completed items' do
    create_list(:todo, 3, :completed)
    Todo.completed.each do |todo|
      expect(todo.completed).to be_truthy
    end
    expect(Todo.completed.length).to be(3)
  end

end
