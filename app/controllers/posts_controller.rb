class PostsController < ApplicationController

  def index
    @posts = Post.all
  end
  def new
    @post = Post.new
  end
  def create
    generate_prompt_for_dalle(post_params[:content])
    post = Post.new(post_params)
    post.save
    redirect_to root_path
  end
  private 
  def post_params
    params.require(:post).permit(:content).merge(user: current_user)
  end

  def generate_prompt_for_dalle(content)
    client = OpenAI::Client.new

    prompt = <<~PROMPT
      You are an AI capable of generating prompts to create the perfect image based on a given text. Please provide the output in English, in a format suitable for direct use as a prompt. It's desirable that the prompts can generate specific images not only from abstract information but also from the emotions and content of the text.

      ## Input text
        #{content}

      ## Output Format
        prompt:
        xxxxx, xxxxx, xxxxx, …
    PROMPT
    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo", # 必須
            messages: [{ role: "user", content: prompt}],
            temperature: 0.7,
        })

    response.dig("choices", 0, "message", "content")
  end
end
