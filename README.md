# README

User Stories

1. Find Recipes by all selected ingredients
As a user, I want to search for recipes that match all the ingredients I have so that I can discover meals I can fully prepare.
I can input multiple ingredients, and the app will show only recipes that include all of them.

2. Find recipes by at least one ingredient
As a user, I want to find recipes that match at least one of my ingredients so that I can make use of what I have at home.

3. Ingredient suggestions
As a user, I want real-time suggestions while typing ingredients so that I can quickly find and add them without typing full names.


Future Enhancements
Expand ingredient matching to group similar items (e.g., flour matches oat flour).
Improve relevance ranking for recipes with partial ingredient matches.
Add sorting options (e.g., by preparation time, popularity).
Introduce filtering (e.g., vegetarian recipes, difficulty level).

The database is pre-filled with a small sample of recipes for demonstration purposes.

### Dependencies

- Ruby (3.2.2 recommended)
- Ruby on Rails (7.0 recommended)
- PostgreSQL
- Bundler
- Yarn

### Installation

Assuming you work on macOS and use [rvm]:

1. Install dependencies listed in the [dependencies section](#dependencies)

    ```shell
    rvm install 3.2.2 && rvm use 3.2.2
    brew update
    ```

2. Clone the repository and change the directory and install dependencies:

    ```shell
    git clone https://github.com/iku-avery/cookit && cd cookit
    bundle install
    yarn install
    ```

3. Setup database:
    ```shell
        rails db:create && rails db:migrate
    ```

4. Fill the database

    ```
        rails 'recipes:import'
    ```

or setup limit and batch:

    ```
        rails 'recipes:import[500, 100]'
    ```


### Running Tests

Execute the following command to run the tests:

```shell
    bundle exec rspec spec
```
