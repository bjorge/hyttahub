from playwright.sync_api import sync_playwright, expect

def run(playwright):
    browser = playwright.chromium.launch(headless=True)
    context = browser.new_context()
    page = context.new_page()

    # This is a placeholder for the actual URL
    # I will need to find the correct URL to navigate to
    page.goto("http://localhost:56158")

    # Click the account settings button
    page.click('//button[@aria-label="Account Settings"]')

    # Verify that the "Import Site" option is visible
    import_site_option = page.locator('text="Import Site"')
    expect(import_site_option).to_be_visible()

    # Click the "Import Site" option
    import_site_option.click()

    # Verify that the page has navigated to the import site screen
    expect(page).to_have_url(containing="importsite")

    # Take a screenshot of the import site screen
    page.screenshot(path="jules-scratch/verification/import_site_screen.png")

    browser.close()

with sync_playwright() as playwright:
    run(playwright)