require "rails_helper"

feature "Todos" do

  feature "get / (no todo)" do
    scenario "should show no todo" do
      visit "/"
      check_todo(page, 0, 0, :all)
    end
  end

  feature "get /" do
    background do
      FactoryBot.create_list(:todo, 2)
      FactoryBot.create_list(:todo, 3, :completed)
    end
    scenario "should show all todos" do
      visit "/"
      check_todo(page, 2, 3, :all)
    end
  end

  feature "get /todos/active" do
    background do
      FactoryBot.create_list(:todo, 2)
      FactoryBot.create_list(:todo, 3, :completed)
    end
    scenario "should show only active todo" do
      visit "/todos/active"
      check_todo(page, 2, 3, :active)
    end
  end

  feature "get /todos/completed" do
    background do
      FactoryBot.create_list(:todo, 2)
      FactoryBot.create_list(:todo, 3, :completed)
    end
    scenario "should show only completed todo" do
      visit "/todos/completed"
      check_todo(page, 2, 3, :completed)
    end
  end

  feature "clicking completed checkbox of the certain todo" do
    before do
      @todo = FactoryBot.create(:todo)
    end
    scenario "should toggle todo's completed attribute", js: true do
      visit '/'
      checkbox = page.find(get_todo_selector(@todo) + " input[type=checkbox]")

      checkbox.click
      wait_for_ajax
      expect(page.has_css?(get_todo_selector(@todo) + ".completed")).to be_truthy

      checkbox.click
      wait_for_ajax
      expect(page.has_css?(get_todo_selector(@todo) + ".completed")).to be_falsy
    end
  end

  feature "clicking all-completed checkbox" do
    background do
      @todos = FactoryBot.create_list(:todo, 3)
    end
    scenario "should toggle all todo's attribute" , js: true do
      visit "/"
      toggle_all_checkbox = page.find("#toggle-all")

      # toggle all for completed
      toggle_all_checkbox.click
      wait_for_ajax
      @todos.each do |todo|
        expect(page.has_css?(get_todo_selector(todo) + ".completed")).to be_truthy
      end

      # toggle all for active
      toggle_all_checkbox.click
      wait_for_ajax
      @todos.each do |todo|
        expect(page.has_css?(get_todo_selector(todo) + ".completed")).to be_falsy
      end
    end
  end

  feature "new todo title is inputed" do
    scenario "new todo should be created" , js:true do
      visit "/"
      # input text with enter
      page.find("#new-todo").set("create new todo test \n")
      wait_for_ajax
      inputed_title = page.find("#todo-list li [data-behavior=todo_title]")
      expect(inputed_title.assert_text("create new todo test")).to be_truthy
    end
  end

  feature "todo's title is doble clicked" do
    background do
      @todo = FactoryBot.create(:todo)
    end
    scenario "todo's title should able to update title", js: true do
      visit "/"
      todo_dom = page.find(get_todo_selector(@todo))
      todo_dom.double_click
      todo_edit_node = page.find(get_todo_selector(@todo) + " [data-behavior=todo_title_input]")
      # edit title with enter
      todo_edit_node.set("update new todo test \n")
      wait_for_ajax
      inputed_title = page.find(get_todo_selector(@todo) + " [data-behavior=todo_title]")
      expect(inputed_title.assert_text("update new todo test")).to be_truthy
    end
  end

  feature "todo's completed checkbox is clicked" do
    background do
      @todo = FactoryBot.create(:todo)
    end
    scenario "todo should be deleted", js: true do
      visit "/"
      page.find(get_todo_selector(@todo)).hover
      page.find(get_todo_selector(@todo) + " button.destroy").click
      wait_for_ajax
      check_todo(page, 0, 0, :all)
    end
  end

  feature "todo's all-completed checkbox is clicked" do
    background do
      @todos = FactoryBot.create_list(:todo, 5, :completed)
    end
    scenario "all todos should be deleted", js: true do
      visit "/"
      click_button("clear-completed")
      wait_for_ajax
      check_todo(page, 0, 0, :all)
    end
  end

end
