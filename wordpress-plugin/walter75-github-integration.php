<?php
/**
 * Plugin Name: Walter75 GitHub Integration
 * Plugin URI: https://github.com/walter75-Consulting/Business-Central-Apps
 * Description: Display Business Central Apps from GitHub with BC brand styling
 * Version: 1.0.0
 * Author: Sebastian Walter (@walter75)
 * Author URI: https://www.walter75.de
 * License: MIT
 * Text Domain: walter75-github
 */

// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

class Walter75_GitHub_Integration {
    
    private $github_owner = 'walter75-Consulting';
    private $github_repo = 'Business-Central-Apps';
    private $cache_duration = 3600; // 1 hour
    
    public function __construct() {
        add_action('wp_enqueue_scripts', [$this, 'enqueue_styles']);
        add_shortcode('bc_apps', [$this, 'display_bc_apps']);
        add_shortcode('github_repo_card', [$this, 'display_repo_card']);
        add_shortcode('github_releases', [$this, 'display_releases']);
        add_shortcode('github_stats', [$this, 'display_stats']);
    }
    
    /**
     * Enqueue plugin styles
     */
    public function enqueue_styles() {
        wp_enqueue_style(
            'walter75-github-style',
            plugins_url('assets/style.css', __FILE__),
            [],
            '1.0.0'
        );
    }
    
    /**
     * Get data from GitHub API with caching
     */
    private function get_github_data($endpoint) {
        $cache_key = 'walter75_github_' . md5($endpoint);
        $cached_data = get_transient($cache_key);
        
        if (false !== $cached_data) {
            return $cached_data;
        }
        
        $url = 'https://api.github.com/' . $endpoint;
        $response = wp_remote_get($url, [
            'headers' => [
                'Accept' => 'application/vnd.github.v3+json',
                'User-Agent' => 'WordPress-Walter75-Plugin'
            ]
        ]);
        
        if (is_wp_error($response)) {
            return false;
        }
        
        $data = json_decode(wp_remote_retrieve_body($response));
        set_transient($cache_key, $data, $this->cache_duration);
        
        return $data;
    }
    
    /**
     * Display Business Central Apps overview
     * Shortcode: [bc_apps]
     */
    public function display_bc_apps($atts) {
        $atts = shortcode_atts([
            'show_docs' => 'true',
            'show_stats' => 'true'
        ], $atts);
        
        $repo_data = $this->get_github_data("repos/{$this->github_owner}/{$this->github_repo}");
        
        if (!$repo_data) {
            return '<p>Unable to load GitHub data.</p>';
        }
        
        ob_start();
        ?>
        <div class="walter75-github-container">
            <!-- Hero Section -->
            <div class="bc-hero">
                <div class="bc-hero-content">
                    <h2>🚀 Business Central Extensions</h2>
                    <p class="bc-subtitle">Open-source, community-driven extensions for Microsoft Dynamics 365 Business Central</p>
                    
                    <?php if ($atts['show_stats'] === 'true'): ?>
                    <div class="bc-stats">
                        <div class="bc-stat">
                            <span class="stat-icon">⭐</span>
                            <span class="stat-value"><?php echo esc_html($repo_data->stargazers_count); ?></span>
                            <span class="stat-label">Stars</span>
                        </div>
                        <div class="bc-stat">
                            <span class="stat-icon">🔀</span>
                            <span class="stat-value"><?php echo esc_html($repo_data->forks_count); ?></span>
                            <span class="stat-label">Forks</span>
                        </div>
                        <div class="bc-stat">
                            <span class="stat-icon">👁️</span>
                            <span class="stat-value"><?php echo esc_html($repo_data->watchers_count); ?></span>
                            <span class="stat-label">Watchers</span>
                        </div>
                        <div class="bc-stat">
                            <span class="stat-icon">📝</span>
                            <span class="stat-value"><?php echo esc_html($repo_data->open_issues_count); ?></span>
                            <span class="stat-label">Open Issues</span>
                        </div>
                    </div>
                    <?php endif; ?>
                    
                    <div class="bc-actions">
                        <a href="<?php echo esc_url($repo_data->html_url); ?>" 
                           class="bc-button bc-button-primary" 
                           target="_blank">
                            <span>📦</span> View on GitHub
                        </a>
                        <?php if ($atts['show_docs'] === 'true'): ?>
                        <a href="https://walter75-consulting.github.io/Business-Central-Apps/" 
                           class="bc-button bc-button-secondary"
                           target="_blank">
                            <span>📚</span> Documentation
                        </a>
                        <?php endif; ?>
                        <a href="<?php echo esc_url($repo_data->html_url); ?>/discussions" 
                           class="bc-button bc-button-secondary"
                           target="_blank">
                            <span>💬</span> Discussions
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Apps Grid -->
            <div class="bc-apps-grid">
                <?php
                $apps = [
                    [
                        'name' => 'Packages',
                        'icon' => '📦',
                        'description' => 'Comprehensive package management and shipping label printing',
                        'features' => ['Barcode Scanning', 'SendCloud Integration', 'PrintNode Support'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/packages.html'
                    ],
                    [
                        'name' => 'OAuth 2.0',
                        'icon' => '🔐',
                        'description' => 'OAuth 2.0 authentication framework for external API integrations',
                        'features' => ['Token Management', 'Refresh Logic', 'Multi-Provider'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/oauth.html'
                    ],
                    [
                        'name' => 'BaseApp Basic',
                        'icon' => '🏗️',
                        'description' => 'Foundation extensions with shared functionality',
                        'features' => ['Core Utilities', 'Common Functions', 'Base Tables'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/baseapp.html'
                    ],
                    [
                        'name' => 'BDE Terminal',
                        'icon' => '⚡',
                        'description' => 'Manufacturing data entry terminals with custom controls',
                        'features' => ['Touch Interface', 'Real-time Data', 'Custom Buttons'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/bde-terminal.html'
                    ],
                    [
                        'name' => 'PrintNode',
                        'icon' => '🖨️',
                        'description' => 'Cloud printing integration with PrintNode service',
                        'features' => ['Cloud Printing', 'Label Printing', 'Multi-Printer'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/printnode.html'
                    ],
                    [
                        'name' => 'SendCloud',
                        'icon' => '📮',
                        'description' => 'Shipping integration with SendCloud platform',
                        'features' => ['Multi-Carrier', 'Label Generation', 'Tracking'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/sendcloud.html'
                    ],
                    [
                        'name' => 'Freight Prices',
                        'icon' => '💰',
                        'description' => 'Dynamic freight price calculation and management',
                        'features' => ['Price Rules', 'Weight-based', 'Zone Management'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/freight-prices.html'
                    ],
                    [
                        'name' => 'Color Master',
                        'icon' => '🎨',
                        'description' => 'Color management and variant handling',
                        'features' => ['Color Codes', 'Variant Mapping', 'Visual Display'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/color-master.html'
                    ],
                    [
                        'name' => 'Contact Relations',
                        'icon' => '👥',
                        'description' => 'Enhanced contact and relationship management',
                        'features' => ['Relationship Types', 'Contact Hierarchy', 'Notes'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/contact-relations.html'
                    ],
                    [
                        'name' => 'XML Import',
                        'icon' => '📄',
                        'description' => 'XML data import and processing utilities',
                        'features' => ['XML Parsing', 'Data Mapping', 'Validation'],
                        'doc_url' => 'https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/xml-import.html'
                    ]
                ];
                
                foreach ($apps as $app):
                ?>
                <div class="bc-app-card">
                    <div class="bc-app-icon"><?php echo $app['icon']; ?></div>
                    <h3 class="bc-app-title"><?php echo esc_html($app['name']); ?></h3>
                    <p class="bc-app-description"><?php echo esc_html($app['description']); ?></p>
                    <ul class="bc-app-features">
                        <?php foreach ($app['features'] as $feature): ?>
                        <li>✓ <?php echo esc_html($feature); ?></li>
                        <?php endforeach; ?>
                    </ul>
                    <a href="<?php echo esc_url($app['doc_url']); ?>" 
                       class="bc-app-link"
                       target="_blank">
                        Learn More →
                    </a>
                </div>
                <?php endforeach; ?>
            </div>
            
            <!-- Footer Info -->
            <div class="bc-footer-info">
                <p>
                    <strong>License:</strong> MIT License | 
                    <strong>Author:</strong> Sebastian Walter (@walter75) | 
                    <a href="https://www.walter75.de" target="_blank">walter75.de</a>
                </p>
                <p style="font-size: 0.9em; color: #666;">
                    Personal open-source project - not a commercial service
                </p>
            </div>
        </div>
        <?php
        return ob_get_clean();
    }
    
    /**
     * Display repository card
     * Shortcode: [github_repo_card]
     */
    public function display_repo_card($atts) {
        $atts = shortcode_atts([
            'owner' => $this->github_owner,
            'repo' => $this->github_repo
        ], $atts);
        
        $repo_data = $this->get_github_data("repos/{$atts['owner']}/{$atts['repo']}");
        
        if (!$repo_data) {
            return '<p>Unable to load repository data.</p>';
        }
        
        ob_start();
        ?>
        <div class="github-repo-card">
            <div class="repo-header">
                <h3>
                    <span class="repo-icon">📚</span>
                    <?php echo esc_html($repo_data->name); ?>
                </h3>
                <span class="repo-visibility"><?php echo $repo_data->private ? '🔒 Private' : '🌐 Public'; ?></span>
            </div>
            <p class="repo-description"><?php echo esc_html($repo_data->description); ?></p>
            <div class="repo-stats-row">
                <span>⭐ <?php echo esc_html($repo_data->stargazers_count); ?> stars</span>
                <span>🔀 <?php echo esc_html($repo_data->forks_count); ?> forks</span>
                <span>👁️ <?php echo esc_html($repo_data->watchers_count); ?> watching</span>
            </div>
            <?php if (!empty($repo_data->language)): ?>
            <div class="repo-language">
                <span class="language-badge"><?php echo esc_html($repo_data->language); ?></span>
                <?php if (!empty($repo_data->license)): ?>
                <span class="license-badge"><?php echo esc_html($repo_data->license->spdx_id); ?></span>
                <?php endif; ?>
            </div>
            <?php endif; ?>
            <div class="repo-actions">
                <a href="<?php echo esc_url($repo_data->html_url); ?>" 
                   class="repo-button"
                   target="_blank">View on GitHub</a>
                <?php if ($repo_data->has_pages): ?>
                <a href="https://<?php echo esc_attr($atts['owner']); ?>.github.io/<?php echo esc_attr($atts['repo']); ?>/" 
                   class="repo-button repo-button-docs"
                   target="_blank">Documentation</a>
                <?php endif; ?>
            </div>
        </div>
        <?php
        return ob_get_clean();
    }
    
    /**
     * Display latest releases
     * Shortcode: [github_releases limit="5"]
     */
    public function display_releases($atts) {
        $atts = shortcode_atts([
            'owner' => $this->github_owner,
            'repo' => $this->github_repo,
            'limit' => 5
        ], $atts);
        
        $releases = $this->get_github_data("repos/{$atts['owner']}/{$atts['repo']}/releases");
        
        if (!$releases || !is_array($releases)) {
            return '<p>No releases found.</p>';
        }
        
        $releases = array_slice($releases, 0, intval($atts['limit']));
        
        ob_start();
        ?>
        <div class="github-releases">
            <h3 class="releases-title">📦 Latest Releases</h3>
            <?php foreach ($releases as $release): ?>
            <div class="release-item">
                <div class="release-header">
                    <h4 class="release-name">
                        <?php echo esc_html($release->name); ?>
                        <span class="release-tag"><?php echo esc_html($release->tag_name); ?></span>
                    </h4>
                    <span class="release-date">
                        <?php echo date('M j, Y', strtotime($release->published_at)); ?>
                    </span>
                </div>
                <?php if (!empty($release->body)): ?>
                <div class="release-notes">
                    <?php echo wp_kses_post(wpautop(substr($release->body, 0, 300))); ?>
                    <?php if (strlen($release->body) > 300): ?>
                    <span>...</span>
                    <?php endif; ?>
                </div>
                <?php endif; ?>
                <div class="release-meta">
                    <span>👤 <?php echo esc_html($release->author->login); ?></span>
                    <?php if (!empty($release->assets)): ?>
                    <span>📎 <?php echo count($release->assets); ?> assets</span>
                    <?php endif; ?>
                    <a href="<?php echo esc_url($release->html_url); ?>" 
                       target="_blank"
                       class="release-link">View Release →</a>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
        <?php
        return ob_get_clean();
    }
    
    /**
     * Display GitHub statistics
     * Shortcode: [github_stats]
     */
    public function display_stats($atts) {
        $atts = shortcode_atts([
            'owner' => $this->github_owner,
            'repo' => $this->github_repo
        ], $atts);
        
        $repo_data = $this->get_github_data("repos/{$atts['owner']}/{$atts['repo']}");
        $contributors = $this->get_github_data("repos/{$atts['owner']}/{$atts['repo']}/contributors");
        
        if (!$repo_data) {
            return '<p>Unable to load statistics.</p>';
        }
        
        ob_start();
        ?>
        <div class="github-stats-widget">
            <div class="stat-box">
                <div class="stat-value"><?php echo esc_html($repo_data->stargazers_count); ?></div>
                <div class="stat-label">⭐ Stars</div>
            </div>
            <div class="stat-box">
                <div class="stat-value"><?php echo esc_html($repo_data->forks_count); ?></div>
                <div class="stat-label">🔀 Forks</div>
            </div>
            <div class="stat-box">
                <div class="stat-value"><?php echo esc_html($repo_data->open_issues_count); ?></div>
                <div class="stat-label">📝 Issues</div>
            </div>
            <?php if ($contributors && is_array($contributors)): ?>
            <div class="stat-box">
                <div class="stat-value"><?php echo count($contributors); ?></div>
                <div class="stat-label">👥 Contributors</div>
            </div>
            <?php endif; ?>
        </div>
        <?php
        return ob_get_clean();
    }
}

// Initialize plugin
new Walter75_GitHub_Integration();
