# README

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
        rails db:create && rails db:migrate && rails db:seed
    ```


### Running Tests

Execute the following command to run the tests:

```shell
    bundle exec rspec spec
```