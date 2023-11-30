Feature: Add a profile page for representatives

Background: reps have been added to database

    Given the following representatives exist:
    | name | address                             | party       | photo_url                     |
    |Johnny| 1234 Oxford St, Berkeley, CA 94709  | Libertarian | https://google.com/image.jpg  |

    

Scenario: Show the correct columns and info
    When I show the first representative
    Then I should see the following columns: Name, Address, Party
    Then I should see "Johnny"
    Then I should see "Libertarian"