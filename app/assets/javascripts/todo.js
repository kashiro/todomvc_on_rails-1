(function($) {
    var TodoTitleInput;
    TodoTitleInput = class TodoTitleInput {
      constructor(input) {
        this.$input = $(input);
        this.$input.on("keypress", (e) => {
          return this.keypress(e);
        });
        this.$input.on("blur", (e) => {
          return this.blur(e);
        });
      }

      keypress(e) {
        if (e.keyCode === 27) {
          return this.handleEscape();
        } else if (e.keyCode === 13) {
          return this.handleEnter();
        }
      }

      blur() {
        return this.submitFormOrDestroy();
      }

      handleEscape() {
        return this.$input.val(this.$input.data("original-value")).parents("li").removeClass("editing");
      }

      handleEnter() {
        this.submitFormOrDestroy();
        return false;
      }

      submitFormOrDestroy() {
        if (this.$input.val().trim().length === 0) {
          return this.destroyTodo();
        } else {
          return this.submitForm();
        }
      }

      submitForm() {
        return this.$input.parents("form").submit();
      }

      destroyTodo() {
        return this.$input.parents("li").find(".destroy").click();
      }

    };
    return $.fn.todoTitleInput = function() {
      return this.each(function() {
        var data;
        data = $.data(this, 'todoTitleInput');
        if (!data) {
          return data = $.data(this, 'todoTitleInput', new TodoTitleInput(this));
        }
      });
    };
  })($);

  $(document).on("keypress", "[data-behavior~=submit_on_enter]", function(e) {
    if (e.keyCode === 13) {
      if ($(this).val().trim().length) {
        Rails.fire($(this).closest("form")[0], 'submit');
      }
      return e.preventDefault();
    }
  });

  $(document).on("click", "[data-behavior~=submit_on_check]", function() {
    Rails.fire($(this).closest("form")[0], 'submit');
  });

  $(document).on("dblclick", "[data-behavior~=todo_title]", function() {
    $(this).closest("li").addClass("editing").siblings().removeClass("editing");
    return $(this).closest("li").find("[data-behavior~=todo_title_input]").focus();
  });

  $(document).on("focus", "[data-behavior~=todo_title_input]", function() {
    return $(this).todoTitleInput();
  });

  $(document).on("ajax:before", "form[data-remote]", function() {
    return $(this).addClass("submitting");
  });

  $(document).on("ajax:complete", "form[data-remote]", function() {
    return $(this).removeClass("submitting");
  });
