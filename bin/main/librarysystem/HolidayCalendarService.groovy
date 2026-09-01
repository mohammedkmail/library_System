package librarysystem

import grails.gorm.transactions.Transactional

import java.text.SimpleDateFormat
import java.util.concurrent.ConcurrentHashMap

@Transactional(readOnly = true)
class HolidayCalendarService {

    private static final String COUNTRY_CODE = 'PS'
    private static final long CACHE_MILLIS = 12L * 60L * 60L * 1000L
    private static final TimeZone LIBRARY_TIME_ZONE = TimeZone.getTimeZone('Asia/Hebron')

    private static final Map<Integer, Map<String, String>> YEAR_CACHE = new ConcurrentHashMap<>()
    private static final Map<Integer, Long> CACHE_TIME = new ConcurrentHashMap<>()

    boolean isClosed(Date date) {
        holidayFor(date) != null
    }

    String holidayFor(Date date) {
        if (!date) {
            return null
        }

        Calendar calendar = Calendar.getInstance(LIBRARY_TIME_ZONE)
        calendar.time = date

        int year = calendar.get(Calendar.YEAR)
        String key = formatDate(date)

        holidaysForYear(year)[key]
    }

    List<Map> upcomingHolidays(int limit = 6) {
        Date now = new Date()
        Calendar calendar = Calendar.getInstance(LIBRARY_TIME_ZONE)
        calendar.time = now

        int currentYear = calendar.get(Calendar.YEAR)
        String today = formatDate(now)

        Map<String, String> combined = [:]
        combined.putAll(holidaysForYear(currentYear))
        combined.putAll(holidaysForYear(currentYear + 1))

        combined.entrySet()
            .findAll { it.key >= today }
            .sort { a, b -> a.key <=> b.key }
            .take(Math.max(limit, 1))
            .collect { entry ->
                [
                    date: parseDate(entry.key),
                    name: entry.value
                ]
            }
    }

    private Map<String, String> holidaysForYear(int year) {
        Long cachedAt = CACHE_TIME[year]

        if (YEAR_CACHE.containsKey(year) && cachedAt && (System.currentTimeMillis() - cachedAt) < CACHE_MILLIS) {
            return YEAR_CACHE[year]
        }

        Map<String, String> holidays = fallbackHolidays(year)

        try {
            String url = "https://web-api.worldpublicholiday.com/v1/holidays/calendar.ics?country=${COUNTRY_CODE}&year=${year}"
            URLConnection connection = new URL(url).openConnection()
            connection.connectTimeout = 2500
            connection.readTimeout = 3000
            connection.setRequestProperty('User-Agent', 'AlManara-Library/1.0')

            String ics = connection.inputStream.getText('UTF-8')
            Map<String, String> remote = parseIcs(ics)

            if (remote) {
                remote.each { String date, String name ->
                    // Keep a known Arabic fallback label when dates match;
                    // otherwise translate the external event name for the Arabic UI.
                    if (!holidays.containsKey(date)) {
                        holidays[date] = arabicHolidayName(name)
                    }
                }
            }
        } catch (Exception ignored) {
            // The local fallback intentionally keeps reservations working
            // even if the public holiday feed is unavailable.
        }

        YEAR_CACHE[year] = Collections.unmodifiableMap(new LinkedHashMap<>(holidays))
        CACHE_TIME[year] = System.currentTimeMillis()

        YEAR_CACHE[year]
    }

    private Map<String, String> parseIcs(String ics) {
        Map<String, String> result = [:]
        if (!ics) {
            return result
        }

        List<String> unfolded = []
        ics.readLines().each { String line ->
            if ((line.startsWith(' ') || line.startsWith('\t')) && unfolded) {
                unfolded[unfolded.size() - 1] = unfolded.last() + line.substring(1)
            } else {
                unfolded << line
            }
        }

        String currentDate
        String currentSummary
        boolean inEvent = false

        unfolded.each { String line ->
            if (line == 'BEGIN:VEVENT') {
                inEvent = true
                currentDate = null
                currentSummary = null
            } else if (line == 'END:VEVENT') {
                if (inEvent && currentDate && currentSummary) {
                    result[currentDate] = cleanSummary(currentSummary)
                }
                inEvent = false
            } else if (inEvent && line.startsWith('DTSTART')) {
                String raw = line.substring(line.indexOf(':') + 1).trim()
                if (raw ==~ /\d{8}.*/) {
                    currentDate = raw.substring(0, 8).replaceFirst(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3')
                }
            } else if (inEvent && line.startsWith('SUMMARY:')) {
                currentSummary = line.substring('SUMMARY:'.length())
            }
        }

        result
    }

    private String cleanSummary(String value) {
        value
            ?.replace('\\,', ',')
            ?.replace('\\;', ';')
            ?.replace('\\n', ' ')
            ?.trim() ?: 'عطلة رسمية'
    }


    private String arabicHolidayName(String value) {
        String cleaned = cleanSummary(value)
        String normalized = cleaned?.toLowerCase(Locale.ENGLISH) ?: ''

        Map<String, String> names = [
            'new year'             : 'رأس السنة الميلادية',
            'orthodox christmas'   : 'عيد الميلاد الشرقي',
            'christmas'            : 'عيد الميلاد المجيد',
            'international women'  : 'يوم المرأة العالمي',
            'women\'s day'         : 'يوم المرأة العالمي',
            'labour day'           : 'عيد العمال',
            'labor day'            : 'عيد العمال',
            'independence'         : 'ذكرى إعلان الاستقلال',
            'isra and mi\'raj'      : 'ذكرى الإسراء والمعراج',
            'isra and miraj'       : 'ذكرى الإسراء والمعراج',
            'eid al-fitr'          : 'عيد الفطر السعيد',
            'eid al fitr'          : 'عيد الفطر السعيد',
            'eid ul-fitr'          : 'عيد الفطر السعيد',
            'eid al-adha'          : 'عيد الأضحى المبارك',
            'eid al adha'          : 'عيد الأضحى المبارك',
            'eid ul-adha'          : 'عيد الأضحى المبارك',
            'islamic new year'     : 'رأس السنة الهجرية',
            'hijri new year'       : 'رأس السنة الهجرية',
            'prophet'              : 'ذكرى المولد النبوي الشريف',
            'mawlid'               : 'ذكرى المولد النبوي الشريف',
            'easter'               : 'عيد الفصح'
        ]

        Map.Entry<String, String> match = names.find { String key, String ignored ->
            normalized.contains(key)
        }

        match?.value ?: 'عطلة رسمية'
    }

    private Map<String, String> fallbackHolidays(int year) {
        Map<String, String> result = [
            "${year}-01-01": 'رأس السنة الميلادية',
            "${year}-01-07": 'عيد الميلاد الشرقي',
            "${year}-03-08": 'يوم المرأة العالمي',
            "${year}-05-01": 'عيد العمال',
            "${year}-11-15": 'ذكرى إعلان الاستقلال',
            "${year}-12-25": 'عيد الميلاد المجيد'
        ]

        // Current-year fallback for movable official/religious holidays.
        // The remote feed remains the primary source and overrides these dates.
        if (year == 2026) {
            result.putAll([
                '2026-01-16': 'ذكرى الإسراء والمعراج',
                '2026-03-20': 'عيد الفطر السعيد',
                '2026-03-21': 'عيد الفطر السعيد',
                '2026-03-22': 'عيد الفطر السعيد',
                '2026-04-05': 'عيد الفصح',
                '2026-04-12': 'عيد الفصح الشرقي',
                '2026-05-27': 'عيد الأضحى المبارك',
                '2026-05-28': 'عيد الأضحى المبارك',
                '2026-05-29': 'عيد الأضحى المبارك',
                '2026-05-30': 'عيد الأضحى المبارك',
                '2026-06-16': 'رأس السنة الهجرية',
                '2026-08-25': 'ذكرى المولد النبوي الشريف'
            ])
        }

        result
    }

    private String formatDate(Date date) {
        SimpleDateFormat formatter = new SimpleDateFormat('yyyy-MM-dd')
        formatter.timeZone = LIBRARY_TIME_ZONE
        formatter.format(date)
    }

    private Date parseDate(String value) {
        SimpleDateFormat formatter = new SimpleDateFormat('yyyy-MM-dd')
        formatter.timeZone = LIBRARY_TIME_ZONE
        formatter.parse(value)
    }
}
