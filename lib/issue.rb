class Issue
  attr_accessor :id, :subject, :description, :children, :parent
  def initialize
    @id          = nil
    @subject     = nil
    @description = ''
    @children    = []
    @parent      = nil
    @output_indent = 4
  end

  def save_to_redmine(options={})
    puts to_simple_str

    client=RedmineClient.new
    attrs = {
      project_id: options[:project_id] || Settings.default_project_id,
      subject: subject,
      description: description,
      parent_issue_id: parent_id,
    }
    puts attrs

    result = client.post('issues.json', :issue => attrs)

    @id= result["issue"]["id"]
    children.each(&:save_to_redmine)
  end

  def parent_id
    parent ? parent.id : nil
  end

  def indent
    " "*(parent ? (parent.indent.length+@output_indent) : 0)+"|"
  end

  def to_simple_str
    "<Issue:#{object_id} #{subject}>"
  end

  def to_s()
    str =<<_EOL_
<Issue:#{object_id} #{Settings.host}/issues/#{id}
  @id         = #{id}
  @subject    = #{subject}
  @descripton = #{description}
  @parent     = #{parent ? parent.to_simple_str : ''}
  @children   = 
#{children.map(&:to_s).join("\n")}
_EOL_

  indent + str.split(/\n/).join("\n#{indent}")
  end
end
