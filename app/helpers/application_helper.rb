module ApplicationHelper
  def interests_selection_form(form, user)
    content_tag :div, class: "interests-selection" do
      User.interests_by_category.map do |category, interests|
        content_tag :div, class: "interest-category" do
          content_tag(:h4, category, class: "category-title") +
          content_tag(:div, class: "interest-checkboxes") do
            interests.map do |interest|
              content_tag :label, class: "interest-checkbox" do
                check_box_tag(
                  "user[interest_list][]",
                  interest,
                  user.has_interest?(interest),
                  id: "interest_#{interest.gsub(/[^a-zA-Z0-9]/, '_')}"
                ) +
                content_tag(:span, interest, class: "interest-label")
              end
            end.join.html_safe
          end
        end
      end.join.html_safe
    end
  end

  def user_age(user)
    return "Age not set" unless user.date_of_birth
    age = user.age
    age ? "#{age} years old" : "Age not set"
  end

  def format_date(date)
    return "Date not set" unless date
    date.strftime("%B %d, %Y")
  end

  def time_ago_in_words_short(time)
    # ... existing code ...
  end

  def profile_completion_badge(user)
    percentage = user.profile_completion_percentage
    css_class = case percentage
    when 0..30 then "completion-low"
    when 31..70 then "completion-medium"
    else "completion-high"
    end

    content_tag :span, "#{percentage}% complete", class: "profile-completion-badge #{css_class}"
  end

  def interest_tags(user, limit: nil)
    interests = limit ? user.interests_array.first(limit) : user.interests_array
    return content_tag(:span, "No interests set", class: "no-interests") if interests.empty?

    content_tag :div, class: "interest-tags-display" do
      interests.map do |interest|
        content_tag :span, interest, class: "interest-tag"
      end.join.html_safe
    end
  end
end
