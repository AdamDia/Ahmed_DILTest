/*
 Hello [Author's Name],

 Thank you for your contribution to the project. I've reviewed the PR and have several suggestions to enhance code readability, maintainability, and robustness:

 1. Separation of Concerns: Consider separating data-fetching logic from UI updates for clearer code and improved maintainability.

 2. Error Handling: The URLSession task currently lacks error handling. Addressing potential errors will offer a better user experience.

 3. Code Redundancy: The animation logic for the detailView in both closeshowDetails and showDetail methods is very similar. Consolidating this could make the code cleaner.

 4. Naming: Names like someVC and someCell aren't very descriptive. Using names that depict the purpose or functionality of the class or method would be beneficial.

 5. Use of Constants: Utilizing constants or enums instead of magic numbers or strings can enhance code maintainability.

 6. Data Model: Rather than using [Any]? for dataArray, consider a specific data model. This would clarify the type of data we're handling.

 7. Delegate & DataSource Assignment: Assigning the collectionView's delegate and dataSource can be relocated to viewDidLoad to avert redundant reassignments.

 8. Memory Management: While the UIView.animate(withDuration:animations:completion:) method doesn't typically create a memory leak, it's prudent to be cautious with capturing self in closures. Especially in contexts where the closure might be retained for extended periods (like observers, timers, or network calls), there's a risk of creating a retain cycle leading to memory leaks. As a best practice, using [weak self] can be a preventive measure.

 You've done a commendable job on the initial implementation. A few tweaks will elevate the quality even further. Please let me know if you have any questions or need clarification on any points.

 Best regards,
 Ahmed

 */
