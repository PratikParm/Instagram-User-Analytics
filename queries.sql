-- MARKETING ANALYSIS
-- Loyal Users
SELECT id, username FROM ig_clone.users
ORDER BY created_at
LIMIT 5;

-- Inactive Users
SELECT id, username FROM ig_clone.users
WHERE id NOT IN (SELECT user_id FROM ig_clone.photos);

-- Count of inactive users
SELECT COUNT(*) AS count_of_inactive_users
FROM ig_clone.users
WHERE id NOT IN (SELECT user_id FROM ig_clone.photos);

-- Contest Winner
SELECT users.id AS user_id, users.username, users.created_at AS user_created_at, 
photos.id AS photo_id, photos.image_url, COUNT(likes.photo_id) AS like_count
FROM ig_clone.users AS users
JOIN ig_clone.photos AS photos ON users.id = photos.user_id
JOIN ig_clone.likes AS likes ON photos.id = likes.photo_id
GROUP BY photos.id
ORDER BY like_count DESC
LIMIT 1;

-- Hashtag Research
SELECT tags.id, tags.tag_name, COUNT(photo_tags.tag_id) AS frequency
FROM ig_clone.tags AS tags
JOIN ig_clone.photo_tags AS photo_tags ON tags.id = photo_tags.tag_id
GROUP BY photo_tags.tag_id
ORDER BY frequency DESC
LIMIT 5;

-- Ad Campaign
SELECT DAYNAME(users.created_at) AS day_of_week, COUNT(*) AS user_register_count
FROM ig_clone.users AS users
GROUP BY day_of_week
ORDER BY user_register_ DESC
LIMIT 1;
-- ----------------------------------------------------------------

-- INVESTOR METRICS
-- User Engagement
-- Avg posts per user
SELECT AVG(post_count) AS average_posts_per_user
FROM (
    SELECT photos.user_id, COUNT(*) AS post_count
    FROM ig_clone.photos AS photos
    GROUP BY photos.user_id
) AS user_post_counts;

-- photos per user
SELECT (SELECT COUNT(*) FROM ig_clone.photos) / (SELECT COUNT(*) FROM ig_clone.users) 
AS average_photos_per_user;

-- Bots & Fake Accounts
SELECT users.id AS user_id, users.username
FROM ig_clone.likes AS likes
JOIN ig_clone.users AS users ON users.id = likes.user_id
GROUP by likes.user_id
HAVING COUNT(*) = (SELECT COUNT(*) FROM ig_clone.photos)
ORDER by COUNT(*) DESC;

-- Count of potential bots
SELECT COUNT(*) AS number_of_potential_bots
FROM (
    SELECT users.id AS user_id, users.username
    FROM ig_clone.likes AS likes
    JOIN ig_clone.users AS users ON users.id = likes.user_id
    GROUP by likes.user_id
    HAVING COUNT(*) = (SELECT COUNT(*) FROM ig_clone.photos)
) AS subquery;
