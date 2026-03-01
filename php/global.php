<?php
$actual_link = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]/ok4mecachrome";
// //$actual_link = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "//172.28.212.10/mecachrome"; //server

function isValidDate($date)
{
    if ($date == '0000-00-00')
        return false;
    return (strtotime($date) !== false);
}

function breakString($str, $lim)
{
    return substr($str, 0, $lim) . " " . ((strlen($str) > $lim) ? '...' : '');
}

function generateWithLeadingZeros($number, $desiredDigits)
{
    $formattedNumber = str_pad($number, $desiredDigits, '0', STR_PAD_LEFT);
    return $formattedNumber;
}

if (!function_exists('str_starts_with')) {
    function str_starts_with($haystack, $needle) {
        return $needle !== '' && strpos($haystack, $needle) === 0;
    }
}
if (!function_exists('str_contains')) {
    function str_contains($haystack, $needle) {
        return $needle !== '' && strpos($haystack, $needle) !== false;
    }
}
if (!function_exists('str_ends_with')) {
    function str_ends_with($haystack, $needle) {
        return $needle !== '' && substr($haystack, -strlen($needle)) === $needle;
    }
}

function stripAccents($string)
{
    $table = array(
        'Š' => 'S',
        'š' => 's',
        'Đ' => 'Dj',
        'đ' => 'dj',
        'Ž' => 'Z',
        'ž' => 'z',
        'Č' => 'C',
        'č' => 'c',
        'Ć' => 'C',
        'ć' => 'c',
        'À' => 'A',
        'Á' => 'A',
        'Â' => 'A',
        'Ã' => 'A',
        'Ä' => 'A',
        'Å' => 'A',
        'Æ' => 'A',
        'Ç' => 'C',
        'È' => 'E',
        'É' => 'E',
        'Ê' => 'E',
        'Ë' => 'E',
        'Ì' => 'I',
        'Í' => 'I',
        'Î' => 'I',
        'Ï' => 'I',
        'Ñ' => 'N',
        'Ò' => 'O',
        'Ó' => 'O',
        'Ô' => 'O',
        'Õ' => 'O',
        'Ö' => 'O',
        'Ø' => 'O',
        'Ù' => 'U',
        'Ú' => 'U',
        'Û' => 'U',
        'Ü' => 'U',
        'Ý' => 'Y',
        'Þ' => 'B',
        'ß' => 'Ss',
        'à' => 'a',
        'á' => 'a',
        'â' => 'a',
        'ã' => 'a',
        'ä' => 'a',
        'å' => 'a',
        'æ' => 'a',
        'ç' => 'c',
        'è' => 'e',
        'é' => 'e',
        'ê' => 'e',
        'ë' => 'e',
        'ì' => 'i',
        'í' => 'i',
        'î' => 'i',
        'ï' => 'i',
        'ð' => 'o',
        'ñ' => 'n',
        'ò' => 'o',
        'ó' => 'o',
        'ô' => 'o',
        'õ' => 'o',
        'ö' => 'o',
        'ø' => 'o',
        'ù' => 'u',
        'ú' => 'u',
        'û' => 'u',
        'ý' => 'y',
        'ý' => 'y',
        'þ' => 'b',
        'ÿ' => 'y',
        'Ŕ' => 'R',
        'ŕ' => 'r'
    );

    return strtr($string, $table);
}

function createRegex($string)
{
    $infoPesquisa = strtolower(stripAccents("" . $string . ""));

    // Divide a string em palavras
    $words = explode(' ', $infoPesquisa);

    // Gera todas as permutações possíveis
    $patterns = permuteT($words);

    // Cria a expressão regular unindo todas as permutações com alternância
    $pattern = implode('|', $patterns);

    return $pattern;
}
function permuteT($words, $prefix = '')
{
    $results = [];
    if (count($words) === 0) {
        $results[] = $prefix;
    } else {
        for ($i = 0; $i < count($words); $i++) {
            $newPrefix = $prefix . ($prefix ? '.*' : '') . $words[$i];
            $remaining = array_slice($words, 0, $i) + array_slice($words, $i + 1);
            $results = array_merge($results, permuteT($remaining, $newPrefix));
        }
    }
    return $results;
}