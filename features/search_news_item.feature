Feature: Select a representative and issue, then click Search

Background: reps have been added to database and logged in to google
    
    Given the following representatives exist:
    | name | address                             | party       | photo_url                     |
    |Johnny| 1234 Oxford St, Berkeley, CA 94709  | Libertarian | https://google.com/image.jpg  |

    Then I show the first news
    Then I follow "Add News Article"
    Then I press "Sign in with Google"


Scenario: Clicking Add News Article shows search page
    When I show the first news
    Then I should see "Johnny"
    Then I follow "Add News Article"
    Then I should see "Edit news article"
    Then I press "Search"