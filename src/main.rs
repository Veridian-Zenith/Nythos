use std::io::{self, Write};
mod engine;
use engine::core::Nythos;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut nythos = Nythos::new();

    println!("Welcome to Nythos AI Assistant");
    println!("Based on Blue Diamond's personality - Professional, precise, and helpful");
    println!("Type your questions or 'exit' to end the session\n");

    loop {
        print!("\nYou: ");
        io::stdout().flush()?;

        let mut user_input = String::new();
        io::stdin().read_line(&mut user_input)?;

        let trimmed_input = user_input.trim();

        if trimmed_input.eq_ignore_ascii_case("exit") {
            break;
        }

        let response = nythos.process_user_input(trimmed_input).await?;
        println!("\n{}", response);
    }

    Ok(())
}
