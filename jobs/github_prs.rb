require 'octokit'

config = Hash[*File.read('github.config').split(/[,\n]+/)]

SCHEDULER.every '1m', :first_in => 0 do |job|
  client = Octokit::Client.new(:access_token => config['token'])

  pull_requests = client.search_issues(config['query'])

  pulls = []
  next if pull_requests.items.size == 0
  pull_requests.items.each do |pull|
    pulls.push({
                 title: pull.title,
                 repo: pull.repository_url.split('/').last,
                 updated_at: pull.updated_at.strftime("%b %-d %Y, %l:%m %p"),
                 creator: "@" + pull.user.login,
                 link: pull.html_url,
               })
  end

  send_event('gh_prs', { header: "Open Pull Requests", pulls: pulls })
end
