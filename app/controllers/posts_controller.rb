class PostsController < ApplicationController

  def index
    @posts = Post.order(created_at: :desc)
  end
  def new
    @post = Post.new
  end
  def create
    post = Post.new(post_params)
    prompt = generate_dalle_prompt(post_params[:content])
    post.prompt = prompt
    image_url = generate_dalle_image(prompt)
    post.image_url = image_url
    post.save
    redirect_to root_path
  end
  private 
  def post_params
    params.require(:post).permit(:content).merge(user: current_user)
  end

  def generate_dalle_prompt(content)
    client = OpenAI::Client.new

    prompt = <<~PROMPT
      You are an AI capable of generating prompts to create the perfect image based on a given text. Please provide keywords in English, in a format suitable for direct use as a prompt. It's desirable that the prompts can generate specific images not only from abstract information but also from the emotions and content of the text.
      Don't contain text that is sensitive, violent or sexsual, for example chest, crotch.
      Names of people and proper nouns should be replaced with common words and included in the Output.      

      ## Output Format
        prompt:
        english_keyword1, english_keyword2, english_keyword3, …
    PROMPT
    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo", # 必須
            messages: [
              { role: "system", content: prompt},
              { role: "user", content: content}],
            temperature: 0.7,
        })

    text = response.dig("choices", 0, "message", "content")
    new_text = text.sub(/^prompt:/, '').strip    
  end
  def generate_dalle_image(prompt)
    client = OpenAI::Client.new
    response_dalle = client.images.generate(parameters: { prompt: prompt, size: "512x512" })

    response_dalle.dig("data", 0, "url")
  end
end
