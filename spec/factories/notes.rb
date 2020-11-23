FactoryBot.define do
  factory :note do
    message "Yeah"
    association :project
    user {project.owner}
  end
end
